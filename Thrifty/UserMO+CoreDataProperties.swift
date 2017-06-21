//
//  UserMO+CoreDataProperties.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/15/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var receives: NSSet?
    @NSManaged public var wants: NSSet?
    @NSManaged public var spends: NSSet?

}

// MARK: Generated accessors for receives
extension UserMO {

    @objc(addReceivesObject:)
    @NSManaged public func addToReceives(_ value: IncomeMO)

    @objc(removeReceivesObject:)
    @NSManaged public func removeFromReceives(_ value: IncomeMO)

    @objc(addReceives:)
    @NSManaged public func addToReceives(_ values: NSSet)

    @objc(removeReceives:)
    @NSManaged public func removeFromReceives(_ values: NSSet)

}

// MARK: Generated accessors for wants
extension UserMO {

    @objc(addWantsObject:)
    @NSManaged public func addToWants(_ value: GoalMO)

    @objc(removeWantsObject:)
    @NSManaged public func removeFromWants(_ value: GoalMO)

    @objc(addWants:)
    @NSManaged public func addToWants(_ values: NSSet)

    @objc(removeWants:)
    @NSManaged public func removeFromWants(_ values: NSSet)

}

// MARK: Generated accessors for spends
extension UserMO {

    @objc(addSpendsObject:)
    @NSManaged public func addToSpends(_ value: ExpenseMO)

    @objc(removeSpendsObject:)
    @NSManaged public func removeFromSpends(_ value: ExpenseMO)

    @objc(addSpends:)
    @NSManaged public func addToSpends(_ values: NSSet)

    @objc(removeSpends:)
    @NSManaged public func removeFromSpends(_ values: NSSet)

}
