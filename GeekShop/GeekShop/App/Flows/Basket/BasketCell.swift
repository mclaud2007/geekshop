//
//  BasketCell.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 18.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class BasketCell: UITableViewCell {
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    override func prepareForReuse() {
        lblTotalPrice.text = nil
        lblQuantity.text = nil
        lblPrice.text = nil
        lblProductName.text = nil
    }
    
    func configureWith(_ product: BasketContents) {
        lblProductName.text = product.productName
        lblPrice.text = String(product.productPrice) + " руб."
        lblQuantity.text = String(product.quantity)
        lblTotalPrice.text = String(product.productPrice * product.quantity) + " руб."
    }

}
