//
//  TransactionMO+CoreDataClass.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/15/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import Foundation
import CoreData

@objc(TransactionMO)
public class TransactionMO: NSManagedObject {
    
    enum type: String {
        case income = "income"
        case expense = "expense"
        case fund = "fund"
    }
    
    class func transaction(with info: TransactionInfo, by user: UserMO, in context: NSManagedObjectContext) -> TransactionMO? {
        let request: NSFetchRequest<TransactionMO> = TransactionMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", info.id)
        
        if let transaction = (try? context.fetch(request))?.first {
            return transaction
        }
        else {
            
            let newTransaction = TransactionMO(context: context)
              newTransaction.daysCycle = info.daysCycle
              newTransaction.amount = info.amount
              newTransaction.date = info.date
              newTransaction.descr = info.descr
              newTransaction.id = info.id
              newTransaction.type = info.type
              newTransaction.amountSoFar = info.amountSoFar
              newTransaction.category = info.category
              newTransaction.owner = user

            
            try! context.save()
            
            return newTransaction
        }
    }
    
    class func deleteTransaction(_ transaction: TransactionMO, context: NSManagedObjectContext) {
        context.delete(transaction)
        try! context.save()
    }


    class func expenseWithDate(_ date: Date, inMOContext context: NSManagedObjectContext) -> [TransactionMO]? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone // this line resolved me the issue of getting one day less than the selected date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        
        let fromdate = "\(result) 00:00" // add hours and mins to fromdate
        let todate = "\(result) 23:59" // add hours and mins to todate
        
        let startDate:NSDate = dateFormatter.date(from: fromdate)! as NSDate
        let endDate:NSDate = dateFormatter.date(from: todate)! as NSDate
        let expense = "expense"
        
        // Set predicate as date being selected date
        let request: NSFetchRequest<TransactionMO> = TransactionMO.fetchRequest()
        
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@) && type == %@",startDate, endDate,expense)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        if let transactions = (try? context.fetch(request)) {
            return transactions
        }
        return nil
    }
    
    class func expenseAvailabel(date: Date, inMOContext context: NSManagedObjectContext) -> Bool {
        if TransactionMO.expenseWithDate(date, inMOContext: context) != nil && (TransactionMO.expenseWithDate(date, inMOContext: context)?.count)! > 0 {
            return true
        }
        return false
    }
}
