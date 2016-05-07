//
//  favoriteListCell.swift
//  stocksearching
//
//  Created by zongyang li on 5/4/16.
//  Copyright © 2016 Frank Lee. All rights reserved.
//

import UIKit

class favoriteListCell: UITableViewCell {

    @IBOutlet weak var symbol: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var lastprice: UILabel!
    
    @IBOutlet weak var change: UILabel!
    
    @IBOutlet weak var marketgap: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
