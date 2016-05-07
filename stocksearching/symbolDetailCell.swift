//
//  symbolDetailCell.swift
//  stocksearching
//
//  Created by zongyang li on 5/4/16.
//  Copyright © 2016 Frank Lee. All rights reserved.
//

import UIKit

class symbolDetailCell: UITableViewCell {

    @IBOutlet weak var key: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var value: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
