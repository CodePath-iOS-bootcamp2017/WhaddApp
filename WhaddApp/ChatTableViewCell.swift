//
//  ChatTableViewCell.swift
//  WhaddApp
//
//  Created by Satyam Jaiswal on 2/24/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}