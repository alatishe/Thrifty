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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let beginningBalance = IncomeInfo(id: UUID().uuidString,
                                          type: "Beginning Balance",
                                          descr: ".hidden",
                                          amount: Double(cashField.text!)!,
                                          daysCycle: 0,
                                          date: Date() as NSDate,
                                          receivedBy: "default")
        print("saving" + beginningBalance.type)
        _ = IncomeMO.incomeWithInfo(beginningBalance, inMOContext: getContext())
        
    }
}
