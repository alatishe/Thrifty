//
//  LineChartVC.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/16/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import Charts

class LineChartVC: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    let date : [Double] = [1, 2, 3, 4, 5, 6, 7]
    let expenses : [Double] = [1, 2, 3, 4, 5, 6, 7]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLineChart(date: date, expenses: expenses)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLineChart(date: [Double], expenses: [Double])
    {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<date.count {
            let dataEntry = ChartDataEntry(x: date[i], y: expenses[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Expenses")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
