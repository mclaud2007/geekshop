//
//  CatalogTableViewCell.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 12.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func prepareForReuse() {
        self.lblPrice.text = nil
        self.lblDescription.text = nil
        self.lblTitle.text = nil
    }
    
    func configureWith(product: Product) {
        self.lblPrice.text = String(product.productPrice)
        self.lblDescription.text = product.productName
        self.lblTitle.text = product.productName
    }

}
