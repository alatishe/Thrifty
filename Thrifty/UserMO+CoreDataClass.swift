//
//  UserMO+CoreDataClass.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/14/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import Foundation
import CoreData

@objc(UserMO)
public class UserMO: NSManagedObject {

    
    class func userWithNameExists(_ name: String, inMOContext context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let _ = (try? context.fetch(request))?.first {
            return true
        }

        return false
    }
    
    class func userWithName(_ name: String, inMOContext context: NSManagedObjectContext) -> UserMO? {
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let user = (try? context.fetch(request))?.first {
            return user
        }
        else {
            
            let user = UserMO(context: context)
            user.name = name
            
            try! context.save()
            
            return user
        }
        
    }
    
    
    
}
