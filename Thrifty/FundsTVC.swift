//
//  FundsTVC.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/19/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class FundsTVC: UITableViewController {
    
//    var titles = ["College Fund", "Paris Trip", "Hawaii Trip", "New Car Fund"]
//    var images = [#imageLiteral(resourceName: "college"), #imageLiteral(resourceName: "paris"), #imageLiteral(resourceName: "hawaii"), #imageLiteral(resourceName: "car") ]
    
    var funds : [TransactionMO] = []
//    var fetchResultsController : NSFetchedResultsController<TransactionMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let fetchRequest : NSFetchRequest<ToDoObjectMO> = ToDoObjectMO.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "iName", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFromCD()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var numOfSections: Int = 0
        if funds.count != 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "You have no funds."
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return funds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FundCell", for: indexPath) as! FundsTVCell

        // Configure the cell...
//        cell.fundImageView.image = images[indexPath.row]
        cell.fundName.text = funds[indexPath.row].descr
        cell.fundAmount.text = String(funds[indexPath.row].amount)
        

        return cell
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func fetchFromCD() {
        var temp : [TransactionMO] = []
        for fund in (UserMO.getActiveUser(getContext())?.funds)! {
            temp.append(fund)
        }
        funds = temp.sorted(by: { $0.descr! < $1.descr! })
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            let context = getContext()
            
            let itemToDelete = (funds[indexPath.row])
            TransactionMO.deleteTransaction(itemToDelete, context: context)
            
            fetchFromCD()
            tableView.reloadData()
            
        default: break
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
