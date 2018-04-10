//
//  FavViewCell.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 4/9/18.
//  Copyright © 2018 Ahmed BHD. All rights reserved.
//

import UIKit

class FavViewCell: UITableViewCell {
    
   
    @IBOutlet weak var PWlbl: UILabel!
    
    @IBOutlet weak var SSIDlbl: UILabel!
    
    @IBOutlet weak var FavImage: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

