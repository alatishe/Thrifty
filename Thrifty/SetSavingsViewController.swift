//
//  SetSavingsViewController.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/9/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class SetSavingsViewController: UIViewController {
    
    
    var firstTime: Bool = true
    var coeff : Double = 0.0
    
    @IBOutlet weak var percentOutput: UILabel!
    @IBOutlet var percentageSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slidSlider(_ sender: UISlider)
    {
        percentOutput.text = (String(format: "%d%@", Int(percentageSlider.value), "%"))
    }

    
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        coeff = Double(Int(percentageSlider.value)) / 100.0
        //save percent var to core data
        
        UserMO.getActiveUser(getContext())?.setSavingsCoeff(coeff, context: getContext())
        UserMO.getActiveUser(getContext())?.completeSetUp(getContext())
        
        self.dismiss(animated: false, completion: nil)
    }

}
