//
//  AddIncomeViewController.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/15/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class AddTransaction: UIViewController {
    
    
    
    @IBOutlet weak var titleField: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var daysCycleField: UITextField!
    
    var type: TransactionMO.type = TransactionMO.type.income
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.titleField.text = "Add an " + type.rawValue.capitalized
        
        self.nameField.placeholder = (type == TransactionMO.type.income ? "e.g. \"iOS app development work\"" : "e.g. \"Gas\"")
        self.typeField.placeholder = (type == TransactionMO.type.income ? "e.g. \"Salary\"" : "e.g. \"Transportation\"")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if (nameField.text == "" ||
            typeField.text == "" ||
            amountField.text == "" ||
            daysCycleField.text == "") {
            let dataAlert = UIAlertController(title: "Error", message: "Make sure all data fields have data", preferredStyle: UIAlertControllerStyle.alert)
            dataAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(dataAlert, animated: true, completion: nil)
        }
        else if Double(amountField.text!)! <= 0.0 || Double(daysCycleField.text!)! <= 0.0 {
            let dataAlert = UIAlertController(title: "Error", message: "Entered amounts must be positive numerical values", preferredStyle: UIAlertControllerStyle.alert)
            dataAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(dataAlert, animated: true, completion: nil)
        }
        else {
            
            let context = getContext()
            
            var amount = Double(amountField.text!)!
            
            switch type {
            case TransactionMO.type.expense:
                amount = -amount
            case TransactionMO.type.fund:
                amount = -amount
            default: break
            }
            
            let newIncome = TransactionInfo(daysCycle: Double(daysCycleField.text!)!,
                                            amount: amount,
                                            date: Date() as NSDate,
                                            descr: nameField.text!,
                                            id: UUID().uuidString,
                                            type: type.rawValue,
                                            amountSoFar: Double(amountField.text!)!,
                                            category: typeField.text!)

            
            _ = UserMO.getActiveUser(context)?.createNewTransaction(with: newIncome, in: context)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    
    
}
