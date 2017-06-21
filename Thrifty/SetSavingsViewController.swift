//
//  SetSavingsViewController.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/9/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit

class SetSavingsViewController: UIViewController {

    
    var firstTime: Bool = true
    var dollarSavings : Double = 0
    
    @IBOutlet var inputSavings: UITextField!
    @IBOutlet var percentageSlider: UISlider!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
        
    }

}
