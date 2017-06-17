//
//  IncomeTableController.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/15/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData


class TransactionTable: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    // Stuff for the picker
    var types: [String] = ["income", "expense"]
    
    // Stuff for the section labels
    var dict = [String: [TransactionMO]]()
    var sectionTitles = [String]()
    
    
    
    // Auto Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        for index in 0..<types.count {
        segmentedControl.insertSegment(withTitle: types[index].capitalized, at: index, animated: false)
        }
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        fetchFromCD()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    // Updating controller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                if newIndexPath.startIndex != 0 {
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                }
            }
        case .delete:
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = newIndexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
//        if let fetchedObjects = controller.fetchedObjects {
//            expenses = fetchedObjects as! [TransactionMO]
//        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    
    
    
    // Sections
    
    //    // On the side
    //    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    ////        if searchController.isActive {
    ////            return [""]
    ////        }
    ////        else {
    //            return sectionTitles
    ////        }
    //    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let values = dict[sectionTitles[section]] {
            return values.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let index = sectionTitles.index(of: title) {
            return index
        }
        return -1
    }
    
    
    
    // Cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "IncomeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! IncomeCell
        
        if let values = dict[sectionTitles[indexPath.section]] {
            let cellItem = values[indexPath.row]
            updateCellContents(in: cell, with: cellItem)
        }
        
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            
                let context = getContext()
                if let itemToDelete = dict[sectionTitles[indexPath.section]]?[indexPath.row] {
                    context.delete(itemToDelete)
                    try! context.save()

                }

                fetchFromCD()
                tableView.reloadData()
            
        default: break
        }
    }
    
    
    
    
    
    
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    func fetchFromCD() {
        dict = [:]
        sectionTitles = []

        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            if let user = UserMO.getActiveUser(getContext())
            {
                for income in user.recurringIncomes! {
                    if income.descr != ".hidden" {
                        addToDict(income)
                    }
                }
            }
        case 1:
            if let user = UserMO.getActiveUser(getContext())
            {
                for expense in user.recurringExpenses! {
                    if expense.descr != ".hidden" {
                        addToDict(expense)
                    }
                }
            }
        default: break
        }
        
        
    }
    
    func addToDict(_ expense: TransactionMO) {
        if let key = expense.type {
            
            if var valsWithSameFirstLetter = dict[key] {
                valsWithSameFirstLetter.append(expense)
                dict[key] = valsWithSameFirstLetter
            }
            else {
                dict[key] = [expense]
            }
        }
        
        sectionTitles = [String](dict.keys)
        sectionTitles.sort()
    }
    
    
    func updateCellContents(in cell: IncomeCell, with cellItem: TransactionMO) {
        cell.nameField.text = cellItem.descr
        cell.daysPeriodField.text = String(cellItem.daysCycle)
        cell.amountField.text = String(cellItem.amount)
        
    }
    
    @IBAction func addIncomePressed(_ sender: UIButton) {
        let AddTypeVC = UIStoryboard(name: "Setup", bundle: nil).instantiateViewController(withIdentifier: "AddTransaction") as! AddTransaction
        
        AddTypeVC.type = types[segmentedControl.selectedSegmentIndex]
        
        present(AddTypeVC, animated: true, completion: nil)
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        fetchFromCD()
        tableView.reloadData()
    }
    
    
    
    
}
