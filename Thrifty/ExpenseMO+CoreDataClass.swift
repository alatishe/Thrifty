//
//  ExpenseMO+CoreDataClass.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/14/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import Foundation
import CoreData

@objc(ExpenseMO)
public class ExpenseMO: NSManagedObject {
    

    
    class func expenseWithInfo(_ info: ExpenseInfo, inMOContext context: NSManagedObjectContext) -> ExpenseMO? {
        let request: NSFetchRequest<ExpenseMO> = ExpenseMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", info.id)
        
        if let expense = (try? context.fetch(request))?.first {
            return expense
        }
        else {
            
            let expense = ExpenseMO(context: context)
            expense.id = info.id
            expense.type = info.type
            expense.descr = info.descr
            expense.amount = info.amount
            expense.daysCycle = info.daysCycle
            expense.date = info.date
            expense.spentBy = UserMO.userWithName(info.spentBy, inMOContext: context)
            
            try! context.save()
            
            return expense
        }
    }
    
    class func expenseWithDate(_ date: Date, inMOContext context: NSManagedObjectContext) -> [ExpenseMO]? {
        
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
        
        // Set predicate as date being selected date
        let request: NSFetchRequest<ExpenseMO> = ExpenseMO.fetchRequest()
        
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)",startDate, endDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        if let expenses = (try? context.fetch(request)) {
            return expenses
        }
        return nil
    }
    
    class func expenseAvailabel(date: Date, inMOContext context: NSManagedObjectContext) -> Bool {
        if ExpenseMO.expenseWithDate(date, inMOContext: context) != nil && (ExpenseMO.expenseWithDate(date, inMOContext: context)?.count)! > 0 {
            return true
        }
        return false
    }
}
