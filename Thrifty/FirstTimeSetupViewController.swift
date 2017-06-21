//
//  FirstTimeSetupViewController.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/12/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class FirstTimeSetupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserMO.userWithNameExists("default", inMOContext: getContext()) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    
    

    @IBAction func continueClicked(_ sender: UIButton) {
        _ = UserMO.userWithName("default", inMOContext: getContext())
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstTimeSequence")
        
        present(viewController, animated: true, completion: nil)

        
    }


}
