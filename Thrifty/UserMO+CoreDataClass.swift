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

    
    // Creates a user with a given name if there is no user with that name already
    class func userWithName(_ name: String, inMOContext context: NSManagedObjectContext) -> UserMO? {
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let user = (try? context.fetch(request))?.first {
            return user
        }
        else {
            
            let user = UserMO(context: context)
            user.name = name
            user.isActive = true
            user.savingCoeff = 0
            user.setUpCompleted = false
            
            do {
                try context.save()
            }
            catch {
                return nil
            }
            
            return user
        }
    }
    
    class func deleteUser(_ user: UserMO, context: NSManagedObjectContext) {
        context.delete(user)
        try! context.save()
    }
    
    class func getUsers(_ context: NSManagedObjectContext) -> [UserMO] {
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        
        if let users = (try? context.fetch(request)) {
            return users
        }

        return []
    }
    
    class func getActiveUser(_ context: NSManagedObjectContext) -> UserMO? {
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        request.predicate = NSPredicate(format: "isActive = true")

        if let user = (try? context.fetch(request))?.first {
            return user
        }
        return nil
    }
    
    func makeActive(_ context: NSManagedObjectContext) {
        self.isActive = true
        try! context.save()
    }
    
    func makeInactive(_ context: NSManagedObjectContext) {
        self.isActive = false
        try! context.save()
    }
    
    class func getIncompleteUsers(_ context: NSManagedObjectContext) -> [UserMO]? {
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        request.predicate = NSPredicate(format: "setUpCompleted = false")
        
        if let users = (try? context.fetch(request)) {
            return users
        }
        return nil
    }
    
    func completeSetUp(_ context: NSManagedObjectContext) {
        self.setUpCompleted = true
        try! context.save()
    }
    

    func createNewTransaction(with info: TransactionInfo, in context: NSManagedObjectContext) {
        _ = TransactionMO.transaction(with: info, by: self, in: context)
    }
    
    var recurringIncomes: [TransactionMO] {
        get {
            var set: [TransactionMO] = []
            for transaction in self.transactions! {
                if (transaction as! TransactionMO).daysCycle != 0
                    && (transaction as! TransactionMO).type == TransactionMO.type.income.rawValue{
                    
                    set.append(transaction as! TransactionMO)
                }
            }
            return set
        }
    }
    
    func sumOfAvgRecurringIncomesFor(numberOfDays days: Double) -> Double {
        var temp: Double = 0.0
        for income in recurringIncomes {
            temp += income.amount / income.daysCycle
        }
        return temp * days
    }
    
    var recurringExpenses: [TransactionMO] {
        get {
            var set: [TransactionMO] = []
            for transaction in self.transactions! {
                if (transaction as! TransactionMO).daysCycle != 0
                    && (transaction as! TransactionMO).type == TransactionMO.type.expense.rawValue {
                    
                    set.append(transaction as! TransactionMO)
                }
            }
            return set
        }
    }
    
    func sumOfAvgRecurringExpensesFor(numberOfDays days: Double) -> Double {
        var temp: Double = 0.0
        for expense in recurringExpenses {
            temp += (expense.amount / expense.daysCycle)
        }
        return temp * days
    }
    
    
    func sumOfAvgSavingsFor(numberOfDays days: Double) -> Double {
        return -sumOfAvgRecurringIncomesFor(numberOfDays: days) * savingCoeff
    }
    
    var funds: [TransactionMO] {
        get {
            var set: [TransactionMO] = []
            for transaction in self.transactions! {
                if (transaction as! TransactionMO).type == TransactionMO.type.fund.rawValue
                    && (transaction as! TransactionMO).amountSoFar != (transaction as! TransactionMO).amount {
                    set.append(transaction as! TransactionMO)
                }
            }
            return set
        }
    }
    
    
    var oneTime: [TransactionMO] {
        
        get {
            var set: [TransactionMO] = []
            for transaction in self.transactions! {
                if ((transaction as! TransactionMO).daysCycle == 0
                    && (transaction as! TransactionMO).descr != ".hidden") {
                    
                    set.append(transaction as! TransactionMO)
                }
            }
            return set
        }
    }
    var oneTimeIncomes: [TransactionMO] {
        get {
            var set: [TransactionMO] = []
            for transaction in self.oneTime {
                if transaction.type == TransactionMO.type.income.rawValue {
                    
                    set.append(transaction)
                }
            }
            return set
        }
    }
    var oneTimeExpenses: [TransactionMO] {
        get {
            var set: [TransactionMO] = []
            for transaction in self.oneTime {
                if transaction.type == TransactionMO.type.expense.rawValue {
                    
                    set.append(transaction)
                }
            }
            return set
        }
    }
    
    var balance: Double {
        get {
            var temp: Double = 0.0
            for transaction in oneTime {
                temp += transaction.amount
            }
            return temp
        }
    }    
    
    func setSavingsCoeff(_ newCoeff: Double, context: NSManagedObjectContext) {
        self.savingCoeff = newCoeff
        
        try! context.save()
    }
    
    func sumOfTransactionsForDay(_ date: Date) -> Double {
        
            var temp: Double = 0.0

            for transaction in oneTime
            {
                let tranDate = transaction.date as Date?
                
                if tranDate?.getStringWithFormat("MM/dd/yy") == date.getStringWithFormat("MM/dd/yy") {
                    temp += transaction.amount
                }
            }
            return temp
    }
    
    func calculateDailyBudget(_ date: Date, context: NSManagedObjectContext) -> Double {
        let sumOfTransactionsToday = sumOfTransactionsForDay(date)
        
        return sumOfAvgRecurringIncomesFor(numberOfDays: 1) + sumOfAvgRecurringExpensesFor(numberOfDays: 1) + sumOfAvgSavingsFor(numberOfDays: 1) + sumOfTransactionsToday
    }
    
    
}
