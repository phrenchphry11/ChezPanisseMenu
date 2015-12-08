//
//  MenuItemCell.swift
//  Chez Panisse Menu
//
//  Created by Holly French on 12/3/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {

    @IBOutlet weak var menuText: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        menuText.font = UIFont(name: "Baskerville", size: 15)
        menuText.textColor = UIColor(red: 0.60, green: 0.3882, blue: 0.3137, alpha: 1.00)
        price.font = UIFont(name: "Baskerville", size: 20)
        price.textColor = UIColor(red: 0.6196, green: 0.5882, blue: 0.4471, alpha: 1.00)
        self.backgroundColor = UIColor(red: 0.851, green: 0.8314, blue: 0.8039, alpha: 1.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
