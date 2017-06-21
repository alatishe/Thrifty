//
//  NameVC.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/15/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class NameVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func savePressed(_ sender: UIButton) {
            if nameField.text != ""
            {
                _ = UserMO.userWithName((nameField?.text)!, inMOContext: getContext())
            }
            else
            {
                let dataAlert = UIAlertController(title: "Error", message: "Please enter a name", preferredStyle: UIAlertControllerStyle.alert)
                dataAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(dataAlert, animated: true, completion: nil)
            }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    

}
