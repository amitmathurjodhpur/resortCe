//
//  ExpenceTableViewCell.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 4/6/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import UIKit

class ExpenceTableViewCell: UITableViewCell {
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var expenseAmount: UILabel!
    @IBOutlet weak var travelDate: UILabel!
    @IBOutlet weak var receiptBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
