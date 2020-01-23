//
//  RestaurantsListCell.swift
//  ZomatoSampleApp
//
//  Created by mallikarjun on 22/01/20.
//  Copyright © 2020 Mallikarjun H. All rights reserved.
//

import UIKit

class RestaurantsListCell: UITableViewCell {

    
    @IBOutlet weak var mainBGImage: UIImageView!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class RestaurantsDetailsCell1: UITableViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class RestaurantsDetailsCell2: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cuisinesLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
