//
//  ProductViewCell.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 22.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit
import Kingfisher

class ProductViewCell: UITableViewCell {
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDescription: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var btnAddToCart: UIButton!
    
    override func prepareForReuse() {
        imgProduct.image = nil
        lblProductName.text = nil
        lblProductPrice.text = nil
        lblProductDescription.text = nil
    }
    
    func configureWith(product: Product) {
        // Если есть фото
        if !product.productImage.isEmpty,
            let imageUrl = URL(string: product.productImage) {
            imgProduct.kf.setImage(with: imageUrl)
        }
        
        lblProductName.text = product.productName
        lblProductDescription.text = product.productDescription
        lblProductPrice.text = String(product.productPrice)
    }
    
    @IBAction func btnAddToCartClicked(_ sender: Any) {
        
    }
}
