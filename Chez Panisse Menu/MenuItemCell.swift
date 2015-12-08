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
        price.font = UIFont(name: "Baskerville", size: 20)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
