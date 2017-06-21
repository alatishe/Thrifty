//
//  ExpenseMO+CoreDataProperties.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/15/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import Foundation
import CoreData


extension ExpenseMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseMO> {
        return NSFetchRequest<ExpenseMO>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var daysCycle: Int16
    @NSManaged public var descr: String?
    @NSManaged public var type: String?
    @NSManaged public var id: String?
    @NSManaged public var spentBy: UserMO?

}
