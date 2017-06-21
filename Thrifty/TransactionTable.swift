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
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var type: TransactionMO.type = TransactionMO.type.income
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    // Stuff for the section labels
    var dict = [String: [TransactionMO]]()
    var sectionTitles = [String]()
    
    
    
    // Auto Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func viewWillAppear(_ animated: Bool) {
        updateTableViewWithNewData()

    }
    
    func updateTableViewWithNewData() {
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
        let cellID = "TransactionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TransactionCell
        
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
                    TransactionMO.deleteTransaction(itemToDelete, context: context)
                }

                updateTableViewWithNewData()
            
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

        switch (self.type) {
        case TransactionMO.type.income:
            if let user = UserMO.getActiveUser(getContext())
            {
                for income in user.recurringIncomes {
                    if income.descr != ".hidden" {
                        addToDict(income)
                    }
                }
            }
        case TransactionMO.type.expense:
            if let user = UserMO.getActiveUser(getContext())
            {
                for expense in user.recurringExpenses {
                    if expense.descr != ".hidden" {
                        addToDict(expense)
                    }
                }
            }
        default: break
        }
        
        
    }
    
    func addToDict(_ expense: TransactionMO) {
        if let key = expense.category {
            
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
    
    
    func updateCellContents(in cell: TransactionCell, with cellItem: TransactionMO) {
        
        // Recurring
        let recurringSt = cellItem.daysCycle == 1 ? "Every day you" : String(format: "Every %1.0f days you", cellItem.daysCycle)
        
        
        // Income/Expense
        let amountSt = cellItem.amount > 0 ? String(format: "receive %1.2f from", cellItem.amount) : String(format: "spend %1.2f on", -cellItem.amount)
        
        
        
        cell.explanationField.text = String(format: "%@ %@ ", recurringSt, amountSt) + cellItem.descr!
        
    }
    
    
}
