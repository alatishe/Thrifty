//
//  StartingInfo.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/9/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import Foundation

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
