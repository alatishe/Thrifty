//
//  UserMO+CoreDataProperties.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/18/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "User")
    }

    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var savingCoeff: Double
    @NSManaged public var setUpCompleted: Bool
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension UserMO {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: TransactionMO)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: TransactionMO)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
