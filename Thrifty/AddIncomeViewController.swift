//
//  AddIncomeViewController.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/15/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class AddIncomeViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var daysCycleField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        print ("income 1.5 is \(income)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        
        if (nameField.text != "" &&
            typeField.text != "" &&
            amountField.text != "" &&
            daysCycleField.text != "") {
            
            let context = getContext()
            
            let newIncome = IncomeInfo(id: UUID().uuidString,
                                         type: typeField.text!,
                                         descr: nameField.text!,
                                         amount: Double(amountField.text!)!,
                                         daysCycle: Int16(daysCycleField.text!)!,
                                         date: dateField.date as NSDate,
                                         receivedBy: "default")
            
            _ = IncomeMO.incomeWithInfo(newIncome, inMOContext: context)
            
            self.dismiss(animated: true, completion: nil)
        }
        else {
            let dataAlert = UIAlertController(title: "Error", message: "Make sure all data fields have data", preferredStyle: UIAlertControllerStyle.alert)
            dataAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(dataAlert, animated: true, completion: nil)
        }
        
    }
    
    
    
    
}
