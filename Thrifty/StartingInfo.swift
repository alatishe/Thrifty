//
//  StartingInfo.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/9/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import Foundation

struct TransactionInfo {
    var daysCycle: Double
    var amount: Double
    var date: NSDate
    var descr: String
    var id: String
    var type: String
    var amountSoFar: Double
    var category: String
}

struct ExpenseInfo {
    var id: String
    var type: String
    var descr: String
    var amount: Double
    var daysCycle: Int16
    var date: NSDate
    var spentBy: String = "default"
}

struct IncomeInfo {
    var id: String
    var type: String
    var descr: String
    var amount: Double
    var daysCycle: Int16
    var date: NSDate
    var receivedBy: String = "default"
}
