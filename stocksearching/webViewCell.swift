//
//  webViewCell.swift
//  stocksearching
//
//  Created by zongyang li on 5/5/16.
//  Copyright © 2016 Frank Lee. All rights reserved.
//

import UIKit

class webViewCell: UITableViewCell {

    @IBOutlet weak var webView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
