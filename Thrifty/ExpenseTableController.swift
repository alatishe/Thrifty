//
//  TVController.swift
//  CIS55Lab2_Boris
//
//  Created by Boris Teodorovich on 5/15/17.
//  Copyright © 2017 Boris Teodorovich. All rights reserved.
//

import UIKit
import CoreData


class ExpenseTableController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    
    
    // Stuff for the section labels
    var expenseDict = [String: [ExpenseMO]]()
    var sectionTitles = [String]()

    
    
    // Auto Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        
//        if let fetchedObjects = controller.fetchedObjects {
//            expenses = fetchedObjects as! [ExpenseMO]
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
        if let values = expenseDict[sectionTitles[section]] {
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
        let cellID = "ExpenseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ExpenseCell
        
        if let values = expenseDict[sectionTitles[indexPath.section]] {
            let cellItem = values[indexPath.row]
            updateCellContents(in: cell, with: cellItem)
        }
        
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            let context = getContext()
            if let itemToDelete = expenseDict[sectionTitles[indexPath.section]]?[indexPath.row] {
                context.delete(itemToDelete)
            }
            try! context.save()
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
        expenseDict = [:]
        sectionTitles = []
        
        if let user = UserMO.userWithName("default", inMOContext: getContext()) {
            for expense in user.spends! {
                addToDict(expense as! ExpenseMO)
            }
        }
        

    }
    
    func addToDict(_ expense: ExpenseMO) {
        if let key = expense.type {
            
            if var valsWithSameFirstLetter = expenseDict[key] {
                valsWithSameFirstLetter.append(expense)
                expenseDict[key] = valsWithSameFirstLetter
            }
            else {
                expenseDict[key] = [expense]
            }
        }
        
        sectionTitles = [String](expenseDict.keys)
        sectionTitles.sort()
    }

    
    func updateCellContents(in cell: ExpenseCell, with cellItem: ExpenseMO) {
        cell.nameField.text = cellItem.descr
        cell.daysPeriodField.text = String(cellItem.daysCycle)
        cell.amountField.text = String(cellItem.amount)

    }
    
}

