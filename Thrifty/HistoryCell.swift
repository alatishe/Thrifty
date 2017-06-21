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

    var transactionMO = [TransactionMO]() {
        didSet{
            if transactionMO.count > 0 {
                if let date = transactionMO[0].date as Date? {
                    lblDate.text = date.getStringWithFormat("dd/mm/yy EEEE")
                }
                
                lblDailyBudget.text = "Daily Budget"
                let dailyBudgetAmount = 24.00
                lblDailyBudgetAmount.text = "$\(dailyBudgetAmount)"
                
                var categoryString = ""
                var amountString = ""
                var totalExpense = 0.00
                for expense in transactionMO {
                    if let category = expense.category {
                        if categoryString.isEmpty {
                            categoryString = categoryString + "\(category)"
                        } else {
                            categoryString = categoryString + "\n\(category)"
                        }
                    }
                    let aString = "\(expense.amount)"
                    let newString = aString.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
                    
                    if amountString.isEmpty {
                         amountString = amountString + "-$\(newString)"
                    } else {
                         amountString = amountString + "\n-$\(newString)"
                    }
                    if let amount = Double(newString) {
                        totalExpense = totalExpense + amount
                    }
                }
                lblType.text = categoryString
                lblTypeAmount.text = amountString
                if (totalExpense - dailyBudgetAmount) < dailyBudgetAmount {
                    lblTotal.text = "$\(totalExpense - dailyBudgetAmount)"
                    lblTotal.textColor = UIColor.green
                } else {
                    lblTotal.text = "-$\(totalExpense - dailyBudgetAmount)"
                    lblTotal.textColor = UIColor.red
                }
            }
        }
    }
}
