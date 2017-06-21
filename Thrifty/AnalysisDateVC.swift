//
//  AnalysisDateVC.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/16/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit

class AnalysisDateVC: UIViewController {

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    @IBOutlet weak var fromDate: UIDatePicker!
    @IBOutlet weak var toDate: UIDatePicker!
    
    var from : Date?
    var to: Date?
//    var initialFromDate : Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromDate.setDate(from!, animated: true)
        toDate.setDate(to!, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Navigation

    
    
    
    
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "saveSegue", sender: self)
    }
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "saveSegue"
        {
            from = fromDate.date
            to = toDate.date
        }
    }
}
