//
//  ResViewCell.swift
//  Yelp
//
//  Created by fer on 2/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessViewCell: UITableViewCell {

  @IBOutlet weak var busPic: UIImageView!
  @IBOutlet weak var busRate: UIImageView!
  @IBOutlet weak var resName: UILabel!
  @IBOutlet weak var resFType: UILabel!
  @IBOutlet weak var revNum: UILabel!
  @IBOutlet weak var milesNum: UILabel!
  @IBOutlet weak var addressT: UILabel!
  
  var restaurant: Business! {
    didSet {
      resName.text = restaurant.name
      addressT.text = restaurant.address
      resFType.text = restaurant.categories
      milesNum.text = restaurant.distance
      revNum.text = "\(restaurant.reviewCount!) Reviews"
      busRate.setImageWith(restaurant.ratingImageURL!)
      if restaurant.imageURL != nil {
        busPic.setImageWith(restaurant.imageURL!)
      }
    }
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      busPic.layer.cornerRadius = 3
      busPic.clipsToBounds = true
      
      resName.preferredMaxLayoutWidth = resName.frame.size.width
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
