//
//  TableViewCell.swift
//  Mosum
//
//  Created by Hassan Talat on 4/11/16.
//  Copyright © 2016 Buff Apps. All rights reserved.
//

import UIKit

class TableViewCell : UITableViewCell {
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var summary: UILabel!
 
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
