//
//  ProductReviewCell.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 15.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class ProductReviewCell: UITableViewCell {
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    override func prepareForReuse() {
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
    func configureWith(review: Review) {
        lblDescription.text = review.description
        lblUserName.text = review.userName
    }
    
}
