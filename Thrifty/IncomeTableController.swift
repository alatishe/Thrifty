//
//  IncomeTableController.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/15/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData


class IncomeTableController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    
    
    // Stuff for the section labels
    var incomeDict = [String: [IncomeMO]]()
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
        
//        if let fetchedObjects = controller.fetchedObjects {
//            expenses = fetchedObjects as! [IncomeMO]
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
        if let values = incomeDict[sectionTitles[section]] {
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
        
        if let values = incomeDict[sectionTitles[indexPath.section]] {
            let cellItem = values[indexPath.row]
            updateCellContents(in: cell, with: cellItem)
        }
        
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            
                let context = getContext()
                if let itemToDelete = incomeDict[sectionTitles[indexPath.section]]?[indexPath.row] {
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
        incomeDict = [:]
        sectionTitles = []

        if let user = UserMO.userWithName("default", inMOContext: getContext()) {
            for income in user.receives! {
                addToDict(income as! IncomeMO)
            }
        }
        
        
    }
    
    func addToDict(_ expense: IncomeMO) {
        if let key = expense.type {
            
            if var valsWithSameFirstLetter = incomeDict[key] {
                valsWithSameFirstLetter.append(expense)
                incomeDict[key] = valsWithSameFirstLetter
            }
            else {
                incomeDict[key] = [expense]
            }
        }
        
        sectionTitles = [String](incomeDict.keys)
        sectionTitles.sort()
    }
    
    
    func updateCellContents(in cell: IncomeCell, with cellItem: IncomeMO) {
        cell.nameField.text = cellItem.descr
        cell.daysPeriodField.text = String(cellItem.daysCycle)
        cell.amountField.text = String(cellItem.amount)
        
    }
    
}
