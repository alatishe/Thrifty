//
//  SetIncomeViewController.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/9/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class SetBBViewController: UIViewController {

    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    //Outlets
    @IBOutlet var cashField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectUser")
        present(VC, animated: false, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var amount: Double
        if cashField.text == ""
        {
            amount = 0
        }
        else
        {
           amount = Double(cashField.text!)!
        }
        
        print(amount)
        
        let beginningBalance = TransactionInfo(daysCycle: 0,
                                               amount: amount,
                                               date: Date() as NSDate,
                                               descr: ".hidden",
                                               id: UUID().uuidString,
                                               type: "income",
                                               amountSoFar: amount,
                                               category: "Beginning Balance")

        
        UserMO.getActiveUser(getContext())?.createNewTransaction(with: beginningBalance, in: getContext())
        
    }
}
