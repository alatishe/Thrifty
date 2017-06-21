//
//  AnalysisVC.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/14/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import Charts

class AnalysisVC: UIViewController {

    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var datesButton: UIButton!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //TODO: change fromAsDate
    var fromAsDate : Date! = Date()
    var toAsDate : Date! = Date()
    
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Pie Chart", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Line Chart", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func selectionDidChange(_ sender: UISegmentedControl)
    {
        updateView()
    }
    
    func setupView()
    {
        setupSegmentedControl()
        updateView()
    }
    
    private lazy var piechartVC: PieChartVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "piechartsegment") as! PieChartVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var linechartVC: LineChartVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "linechartsegment") as! LineChartVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0
        {
            remove(asChildViewController: linechartVC)
            add(asChildViewController: piechartVC)
        }
        else
        {
            remove(asChildViewController: piechartVC)
            add(asChildViewController: linechartVC)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
        

    }
    
    func getPreviousMonth() -> Date
    {
        let curDate = Date()
        let calendar = Calendar.current
        //extract current month
        let curMonth = calendar.component(.month, from: curDate)
        let curDay = calendar.component(.day, from: curDate)
        let curYear = calendar.component(.year, from: curDate)

        let newDateComponents = DateComponents(calendar: nil, timeZone: nil, era: nil, year: curYear, month: curMonth - 1, day: curDay, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let newDate = calendar.date(from: newDateComponents)
        return newDate!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd/yy"
//        datesButton.setTitle(String(formatter.string(from: fromAsDate) + " – " + formatter.string(from: toAsDate)), for: UIControlState.normal)
    }
  



    // MARK: - Navigation

    @IBAction func unwindSave (segue: UIStoryboardSegue)
    {
//        let datePickerVC = segue.source as! AnalysisDateVC
//        fromAsDate = datePickerVC.from
//        toAsDate = datePickerVC.to
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "setDate"
        {
            let dateChangeVC = segue.destination as! AnalysisDateVC
            dateChangeVC.from = fromAsDate
            dateChangeVC.to = toAsDate
        }
    }

}
