//
//  newsCell.swift
//  stocksearching
//
//  Created by zongyang li on 5/4/16.
//  Copyright © 2016 Frank Lee. All rights reserved.
//

import UIKit

class newsCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var publisher: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
