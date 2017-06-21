//
//  IncomeMO+CoreDataClass.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/14/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import Foundation
import CoreData

@objc(IncomeMO)
public class IncomeMO: NSManagedObject {


    class func incomeWithInfo(_ info: IncomeInfo, inMOContext context: NSManagedObjectContext) -> IncomeMO? {
        let request: NSFetchRequest<IncomeMO> = IncomeMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", info.id)
        
        if let income = (try? context.fetch(request))?.first {
            return income
        }
        else {
            
            let income = IncomeMO(context: context)
            income.id = info.id
            income.type = info.type
            income.descr = info.descr
            income.amount = info.amount
            income.daysCycle = info.daysCycle
            income.date = info.date
            income.receivedBy = UserMO.userWithName(info.receivedBy, inMOContext: context)
            
            try! context.save()
            
            return income
        }
    }
    

}
