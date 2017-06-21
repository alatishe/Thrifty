//
//  HistoryCell.swift
//  Thrifty
//
//  Created by Lomesh Pansuriya on 16/06/17.
//  Copyright © 2017 Lomesh Pansuriya. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDailyBudget: UILabel!
    @IBOutlet weak var lblDailyBudgetAmount: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTypeAmount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var expenseMO = [ExpenseMO]() {
        didSet{
            if expenseMO.count > 0 {
                if let date = expenseMO[0].date as Date? {
                    lblDate.text = date.getStringWithFormat("dd/mm/yy EEEE")
                }
                
                lblDailyBudget.text = "Daily Budget"
                lblDailyBudgetAmount.text = "$24"
                
                var typeString = ""
                var moneyString = ""
                var totalExpense = 0.00
                for expense in expenseMO {
                    if let type = expense.type {
                        if typeString.isEmpty {
                            typeString = typeString + "\(type)"
                        } else {
                            typeString = typeString + "\n\(type)"
                        }
                    }
                    if moneyString.isEmpty {
                         moneyString = moneyString + "$\(expense.amount)"
                    } else {
                         moneyString = moneyString + "\n$\(expense.amount)"
                    }
                    totalExpense = totalExpense + expense.amount
                }
                lblType.text = typeString
                lblTypeAmount.text = moneyString
                lblTotal.text = "$\(totalExpense - 24.0)"
            }
        }
    }
}
