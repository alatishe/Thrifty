//
//  FundsTVCell.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/19/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit

class FundsTVCell: UITableViewCell {

    @IBOutlet weak var fundName: UILabel!
    @IBOutlet weak var fundAmount: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var fundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fundAmount.layer.cornerRadius = 3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
