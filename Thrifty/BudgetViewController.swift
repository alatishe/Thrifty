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
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    var myInfo : UserMO!
    var fetchResultsController : NSFetchedResultsController<UserMO>!
    
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var expButton: UIButton!
    @IBOutlet weak var savingsButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        updateDisplay()
//        if !myInfo.setUpCompleted {
//            let AddTypeVC = UIStoryboard(name: "Setup", bundle: nil).instantiateViewController(withIdentifier: "BeginSetup")
//            
//            
//            present(AddTypeVC, animated: false, completion: nil)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func setIncomeClicked(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "Setup", bundle: nil).instantiateViewController(withIdentifier: "SetTransactions") as! TransactionContainer
        viewController.initType = "incomes"
        present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func setExpClicked(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "Setup", bundle: nil).instantiateViewController(withIdentifier: "SetTransactions") as! TransactionContainer
        viewController.initType = "expenses"
        present(viewController, animated: true, completion: nil)
        
//        
    }
    
    @IBAction func setSavingsClicked(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "Setup", bundle: nil).instantiateViewController(withIdentifier: "SetSavings") as! SetSavingsViewController
        present(viewController, animated: true, completion: nil)
        
    }
    
    func updateDisplay() {
        if myInfo != nil {
            
            let income = myInfo.sumOfAvgRecurringIncomesFor(numberOfDays: 30)
            let expense = myInfo.sumOfAvgRecurringExpensesFor(numberOfDays: 30)
            let savings = myInfo.sumOfAvgSavingsFor(numberOfDays: 30)
            
            
            incomeButton.setTitle(String(format: "$%.2f", income), for: UIControlState.normal)
            expButton.setTitle(String(format: "$%.2f", expense), for: UIControlState.normal)
            savingsButton.setTitle(String(format: "$%.2f", savings), for: UIControlState.normal)
        }
    }
    
 
    
    
    
    
    
    
    
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // Fetches data and stores it in myInfo
    func loadData() {
        myInfo = UserMO.getActiveUser(getContext())
    }
    
    
    
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        UserMO.getActiveUser(getContext())!.makeInactive(getContext())
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
