//
//  FundsAddVC.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/19/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class FundsAddVC: UIViewController {

    @IBOutlet weak var newName: UITextField!
    @IBOutlet weak var newAmount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let newInfo = TransactionInfo(daysCycle: 0, amount: Double(newAmount.text!)!, date: Date() as NSDate, descr: newName.text!, id: UUID().uuidString, type: "fund", amountSoFar: 0, category: "")
        _ = TransactionMO.transaction(with: newInfo, by: UserMO.getActiveUser(getContext())!, in: getContext())
        
        self.dismiss(animated: true, completion: nil)
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
