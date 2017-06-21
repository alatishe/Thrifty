//
//  MainViewController.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/9/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var myInfo: UserMO!
    
    
    var dailyBudgetDollars: Double = 0
    var numDaysInMonth: Double = 30
    var netMonthlyIncome: Double = 0
    var expenses : Double = 0
    var extraIncome : Double = 0
    
    // Outlets
    @IBOutlet var dailyBudget: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        loadData()
//
//        
//        //monthly income, subtract recurring expenses and subtract savings
//        //
//        if let info = myInfo {
//            netMonthlyIncome = info.income - info.recurringExpenses - info.savings
//            dailyBudgetDollars = netMonthlyIncome/numDaysInMonth
//            
//            dailyBudget.text = String(format: "$%.2f", dailyBudgetDollars)
//        }
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // Fetches data and stores it in myInfo
    func loadData() {
        let fetchRequest : NSFetchRequest<UserMO> = UserMO.fetchRequest()
        do {
            let fetchedObjects = try getContext().fetch(fetchRequest)
                myInfo = fetchedObjects.first
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func unwindSave(segue: UIStoryboardSegue)
    {
        if let expenseVC = segue.source as? ExpenseVC {
            expenses += expenseVC.amountExpense
            print("total expenses are \(expenses)")
        } else if let extraIncomeVC = segue.source as? ExtraIncomeVC {
            extraIncome += extraIncomeVC.amountIncome
        }
        
    }
    
    @IBAction func unwindCancel(segue: UIStoryboardSegue)
    {
        
    }
}

