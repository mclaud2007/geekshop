//
//  ProductViewController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 15.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit
import Kingfisher

class ProductViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tblReviewsList: UITableView! {
        didSet {
            tblReviewsList.delegate = self
            tblReviewsList.dataSource = self
        }
    }
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    // MARK: Properties
    var productID: Int?
    var product: ProductResult?
    
    let catalogFabric = RequestFactory().makeCatalogFactory()
    let reviewFabric = RequestFactory().makeReviewsFactory()
    var reviewList: GetReviewsResult = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let pID = productID {
            catalogFabric.getProductBy(productId: pID) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case let .success(product):
                    DispatchQueue.main.async {
                        self.productPageInitWith(product: product)
                    }
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddReviewController {
            destination.product = self.product
            destination.productID = productID
        }
    }
}

extension ProductViewController {
    func productPageInitWith(product: ProductResult) {
        self.product = product
        
        lblDescription.text = product.productDescription
        lblProductName.text = product.productName
        lblPrice.text = String(product.productPrice)
        
        // Если есть фотография товара - загрузми
        if let imageSource = product.productImage,
            let image = URL(string: imageSource) {
            
            imgProduct.kf.setImage(with: image)
        }
        
        // Попробуем загрузить отзывы
        productLoadReview()
    }
    
    func productLoadReview() {
        // Попробуем загрузить отзывы
        if let pID = productID {
            reviewFabric.getReviewsForProductBy(productId: pID) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case let .success(reviews):
                    DispatchQueue.main.async {
                        self.reviewList = reviews
                        self.tblReviewsList.reloadData()
                    }
                    
                case .failure(_):
                    break
                }
            }
        }
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblReviewsList.dequeueReusableCell(withIdentifier: "productViewCell") as? ProductReviewCell else {
            preconditionFailure()
        }
        
        cell.configureWith(review: reviewList[indexPath.row])
        
        return cell
    }
}
