//
//  CustomTableViewCell.swift
//  RentaTeam
//
//  Created by Flash Jessi on 11/9/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
