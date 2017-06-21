//
//  TransactionContainer.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/19/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit

class TransactionContainer: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var ContainedTableView: TransactionTable?
    
    
    // Stuff for the picker
    let types: [TransactionMO.type] = [TransactionMO.type.income, TransactionMO.type.expense]
    var initType = TransactionMO.type.income
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        
        if ContainedTableView != nil {
            ContainedTableView?.type = types[segmentedControl.selectedSegmentIndex]
            ContainedTableView?.updateTableViewWithNewData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        for index in 0..<types.count {
            segmentedControl.insertSegment(withTitle: types[index].rawValue.capitalized, at: index, animated: false)
        }
        // Select First Segment
        segmentedControl.selectedSegmentIndex = types.index(of: initType)!
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        ContainedTableView = (segue.destination as! TransactionTable)
        ContainedTableView?.type = types[segmentedControl.selectedSegmentIndex]
    }
 
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        let AddTypeVC = UIStoryboard(name: "Setup", bundle: nil).instantiateViewController(withIdentifier: "AddTransaction") as! AddTransaction
        
        AddTypeVC.type = types[segmentedControl.selectedSegmentIndex]
        
        present(AddTypeVC, animated: true, completion: nil)
    }
    
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        ContainedTableView?.type = types[segmentedControl.selectedSegmentIndex]
        ContainedTableView?.updateTableViewWithNewData()
    }
    
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
