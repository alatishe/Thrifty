//
//  BudgetViewController.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/9/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class BudgetViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var expenseInfo : ExpenseMO!
    var myInfo : UserMO!
    var fetchResultsController : NSFetchedResultsController<UserMO>!
    
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var expButton: UIButton!
    @IBOutlet weak var savingsButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !UserMO.userWithNameExists("default", inMOContext: getContext()) {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstTimeSetup")
            present(viewController, animated: true, completion: nil)
        }
        else {
            loadData()
            updateDisplay()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func setIncomeClicked(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetRecInc") as! IncomeTableController
//        viewController.myInfo = userInfo(self.myInfo)
        present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func setExpClicked(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetRecExp") as! ExpenseTableController
//        viewController.myInfo = userInfo(self.myInfo)
        present(viewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func setSavingsClicked(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetSavings") as! SetSavingsViewController
//        viewController.myInfo = userInfo(self.myInfo)
        present(viewController, animated: true, completion: nil)
        
    }
    
    func updateDisplay() {
        if myInfo != nil {
            
            
            
            incomeButton.setTitle(String(format: "$%.2f", sumOfIncomes()!), for: UIControlState.normal)
            expButton.setTitle(String(format: "$%.2f", sumOfExpenses()!), for: UIControlState.normal)
            savingsButton.setTitle(String(format: "$%.2f", sumOfSavings()!), for: UIControlState.normal)
        }
    }
    
    
    func sumOfIncomes() -> Double? {
        if myInfo.receives != nil {
            var incomes: Double = 0.0
            for income in myInfo.receives! {
                incomes += (income as! IncomeMO).amount
            }
            return incomes
        }
        else {
            return nil
        }
    }
    
    func sumOfExpenses() -> Double? {
        if myInfo.spends != nil {
            var expenses: Double = 0.0
            for expense in myInfo.spends! {
                expenses += (expense as! ExpenseMO).amount
            }
            return expenses
        }
        else {
            return nil
        }
    }
    
    func sumOfSavings() -> Double? {
        if myInfo.wants != nil {
            var goals: Double = 0.0
            for goal in myInfo.wants! {
                goals += (goal as! GoalMO).amount
            }
            return goals
        }
        else {
            return nil
        }
    }

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // Fetches data and stores it in myInfo
    func loadData() {
        myInfo = UserMO.userWithName("default", inMOContext: getContext())
    }
    
}
