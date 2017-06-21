//
//  ExtraIncomeVC.swift
//  Thrifty
//
//  Created by Lomesh Pansuriya on 16/06/17.
//  Copyright © 2017 Lomesh Pansuriya. All rights reserved.
//

import UIKit
import CoreData

class ExtraIncomeVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var inputIncome: UITextField!
    @IBOutlet var typeOfIncome: UIPickerView!
    
    var types : [String] = [String]()
    var amountIncome : Double = 0.0
    var typeSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.typeOfIncome.delegate = self
        self.typeOfIncome.dataSource = self
        
        // Do any additional setup after loading the view.
        types = ["General", "Food", "Transportation", "Shopping", "Groceries", "Entertainment", "Education", "Health", "Family"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeSelectedIndex = row
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveExtraIncome() {
        if types[typeSelectedIndex] != "" && amountIncome != 0 {
            let incomeInfo = IncomeInfo(id: UUID().uuidString, type: types[typeSelectedIndex], descr: "", amount: amountIncome, daysCycle: 0, date: NSDate(), receivedBy: "default")
            _ = IncomeMO.incomeWithInfo(incomeInfo, inMOContext: getContext())
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "saveExtraIncome"
        {
            amountIncome = (inputIncome.text! as NSString).doubleValue
            saveExtraIncome()
        }
    }

}
