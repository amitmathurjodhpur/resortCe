//
//  TripTrackCell.swift
//  ResortCeApp
//
//  Created by Amit Mathur on 1/13/19.
//  Copyright © 2019 AJ12. All rights reserved.
//

import UIKit

class TripTrackCell: UITableViewCell {

    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var tripTimeLabel: UILabel!
    @IBOutlet weak var tripStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
