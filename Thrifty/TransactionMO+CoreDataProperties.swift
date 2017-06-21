//
//  TransactionMO+CoreDataProperties.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/16/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import Foundation
import CoreData


extension TransactionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionMO> {
        return NSFetchRequest<TransactionMO>(entityName: "Transaction")
    }

    @NSManaged public var daysCycle: Double
    @NSManaged public var amount: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var descr: String?
    @NSManaged public var id: String?
    @NSManaged public var type: String?
    @NSManaged public var amountSoFar: Double
    @NSManaged public var category: String?
    @NSManaged public var owner: UserMO?

}
