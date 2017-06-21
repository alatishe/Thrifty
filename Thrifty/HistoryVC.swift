//
//  HistoryVC.swift
//  Thrifty
//
//  Created by Lomesh Pansuriya on 16/06/17.
//  Copyright © 2017 Lomesh Pansuriya. All rights reserved.
//

import UIKit
import CoreData

extension UIColor {

    func colorWithHueDegrees(hue: CGFloat, saturation:CGFloat, brightness:CGFloat) -> UIColor {
        return UIColor.init(hue: (hue/360), saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    func aquaColor() -> UIColor {
        return colorWithHueDegrees(hue: 166, saturation: 0.56, brightness: 0.55)
    }
    
    func paleYellowColor() -> UIColor {
        return colorWithHueDegrees(hue: 60, saturation: 0.2, brightness: 1.0)
    }
}

class HistoryVC: UIViewController, JTCalendarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    
    @IBOutlet weak var weekDayView: JTCalendarWeekDayView!
    
    @IBOutlet weak var calendarContentView: JTVerticalCalendarView!

    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var weekDayHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var changeModeButton: UIButton!
    
    var calendarManager = JTCalendarManager()

    var expenseList: [TransactionMO] = [TransactionMO]()
    var expensesDate = [NSDate]()
    
    var dateSelected = Date()
    var isMonthlySpendingView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarManager.delegate = self
        
        self.calendarManager.settings.pageViewHaveWeekDaysView = false
        self.calendarManager.settings.pageViewNumberOfWeeks = 0
        
        
        self.weekDayView.manager = calendarManager
        weekDayView.reload()
        
        // Generate random events sort by date using a dateformatter for the demonstration
        
        self.calendarManager.menuView = calendarMenuView
        self.calendarManager.contentView = calendarContentView
        self.calendarManager.setDate(Date())
        dateSelected = Date()
        
        self.calendarMenuView.scrollView.isScrollEnabled = false // Scroll not supported with JTVerticalCalendarView
        
        // Set tableview estimated row height.
        self.tableView.estimatedRowHeight = 44
        // Set tableview actuall height.
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        calendarManager.reload()
    }
    
    //MARK: - CalendarManager delegate
    
    // Exemple of implementation of prepareDayView method
    // Used to customize the appearance of dayView
    
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
    
        let viewDay = dayView as! JTCalendarDayView
        viewDay.isHidden = false
        
        // Hiden if from another month
        if viewDay.isFromAnotherMonth {
            viewDay.isHidden = false
        }
    // Today
        else if (calendarManager.dateHelper.date(Date(), isTheSameDayThan: viewDay.date)) {
            viewDay.circleView.isHidden = false
            viewDay.circleView.backgroundColor = UIColor().aquaColor()
            viewDay.dotView.backgroundColor = UIColor.white
            viewDay.textLabel.textColor = UIColor.white
        }
            // Selected date
        else if calendarManager.dateHelper.date(dateSelected, isTheSameDayThan: viewDay.date) {
            viewDay.circleView.isHidden = false
            viewDay.circleView.backgroundColor = UIColor.red
            viewDay.dotView.backgroundColor = UIColor.white
            viewDay.textLabel.textColor = UIColor.white
        }            
            // Other month
        else if !calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: viewDay.date) {
            viewDay.circleView.isHidden = true
            viewDay.dotView.backgroundColor = UIColor.red
            viewDay.textLabel.textColor = UIColor.lightGray
        }
            // Another day of the current month
        else{
            viewDay.circleView.isHidden = true
            viewDay.dotView.backgroundColor = UIColor.red
            viewDay.textLabel.textColor = UIColor.black
        }
    
        if self.haveEventForDay(date: viewDay.date! as NSDate) {
            viewDay.dotView.isHidden = false
        }
        else{
            viewDay.dotView.isHidden = true
        }

        if (calendarManager.dateHelper.date(calendarContentView.date, isTheSameDayThan: viewDay.date)) {
            if self.calendarManager.dateHelper.date(dateSelected, isEqualMonthAndYear: viewDay.date) {
                loadData(dateSelected)
            }
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
    
        let viewDay = dayView as! JTCalendarDayView
        dateSelected = viewDay.date
        
        // Animation for the circleView
        viewDay.circleView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)

        UIView.transition(with: viewDay, duration: 0.3, options: UIViewAnimationOptions(rawValue: 0), animations: {
            viewDay.circleView.transform = CGAffineTransform.identity
            self.calendarManager.reload()
        }, completion: nil)
    
    
    
        // Don't change page in week mode because block the selection of days in first and last weeks of the month
        if calendarManager.settings.weekModeEnabled {
            return
        }
    
    
        // Load the previous or next page if touch a day from another month
    
        if calendarManager.dateHelper.date(calendarContentView.date, isTheSameDayThan: viewDay.date) {
            if calendarContentView.date.compare(viewDay.date) == ComparisonResult.orderedAscending {
                self.calendarContentView.loadNextPage()
            } else {
                self.calendarContentView.loadPreviousPage()
            }
        }
        
    //week view
    //    _calendarManager.settings.weekModeEnabled = YES;
    //    [_calendarManager reload];
    //doesn't change the height of calendarContentView, you have to do it yourself
    }
    
    //MARK: - Fake data
    
    // Used only to have a key for _eventsByDate
    func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    
    func haveEventForDay(date: NSDate) -> Bool {
        if TransactionMO.expenseAvailabel(date: date as Date, inMOContext: getContext()) {
            return true
        }
        return false
    }
    
    @IBAction func changeMode(_ sender: Any) {
//        calendarManager.settings.weekModeEnabled = !calendarManager.settings.weekModeEnabled
//        calendarManager.reload()
        expenseList.removeAll()
        
        var contentViewHeight: CGFloat = 300.0
        var weekDayHeight: CGFloat = 30.0
        if !isMonthlySpendingView {
            contentViewHeight = 0.0
            weekDayHeight = 0.0
            expenseList = TransactionMO.getMonthlyExpense(dateSelected as NSDate, inMOContext: getContext())!
            isMonthlySpendingView = true
        } else {
            expenseList = TransactionMO.expenseWithDate(dateSelected, inMOContext: getContext())!
            isMonthlySpendingView = false
        }
        contentViewHeightConstraint.constant = contentViewHeight
        weekDayHeightConstraint.constant = weekDayHeight
        self.tableView.reloadData()
    }
    
    func loadData(_ date: Date) {
        expenseList.removeAll()
        expenseList = TransactionMO.expenseWithDate(date, inMOContext: getContext())!
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMonthlySpendingView {
            return getRows()
        }
        if expenseList.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "historyCell"
        
        let historyCell = self.tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HistoryCell
        
        
        if isMonthlySpendingView {
            historyCell.headerDate = expensesDate[indexPath.row] as Date
        } else {
            historyCell.headerDate = nil
        }
        
        
        historyCell.transactionMO = expenseList
        
        return historyCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: OtherMethods
    func getRows() -> Int {
        var tempDate = Date()
        var date: NSDate?
        expensesDate.removeAll()
        for expense in expenseList {
            if let d = expense.date {
                tempDate = d as Date
                
                if let tDate = date {
                    if tempDate.getDate() as Date != (tDate as Date) as Date {
                        date = tempDate.getDate()
                        expensesDate.append(expense.date!)
                    }
                } else {
                    date = tempDate.getDate()
                    expensesDate.append(expense.date!)
                }
            }
        }
        return expensesDate.count
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
