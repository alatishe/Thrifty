//
//  IncomeCell.swift
//  Thrifty
//
//  Created by Boris Teodorovich on 6/15/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit

class IncomeCell: UITableViewCell {

    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var daysPeriodField: UILabel!
    @IBOutlet weak var amountField: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
