//
//  ProductViewController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 15.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit
import Kingfisher

class ProductViewController: BaseViewController {
    
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
    @IBOutlet weak var btnAddToBasket: UIButton!
    
    // MARK: Properties
    var reviewList: GetReviewsResult = []
    
    var productID: Int?
    var product: ProductResult?
    
    let catalogFabric = RequestFactory().makeCatalogFactory()
    let reviewFabric = RequestFactory().makeReviewsFactory()
    let basketFabric = RequestFactory().makeBasketFactory()
    
    var isAddReviewClicked: Bool = false
    var isAddToCartClicked: Bool = false
    
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
    
    // MARK: Добавит отзыв
    @IBAction func addReviewClicked() {
        isAddReviewClicked = true
        
        if !isNeedLogin {
            let addReview = app.getScreenPage(storyboard: "Reviews", identifier: "addReviewPage")
            present(addReview, animated: true)
            
        } else {
            login(delegate: self)
        }
    }
        
    // MARK: Добавить товар в корзину
    @IBAction func btnAddToBasketClicked(_ sender: Any) {
        isAddToCartClicked = true
        
        if !isNeedLogin {
            // Если на текущей странице есть товар, то его можно добавить
            if let pID = productID,
                let uID = app.session.userInfo?.idUser {
                    basketFabric.addProductToBasketBy(productId: pID, userId: uID, quantity: 1) { [weak self] response in
                        guard let self = self else { return }
                        
                        switch response.result {
                        case .success(_):
                            DispatchQueue.main.async {
                                self.btnAddToBasket.setTitle("В корзине", for: .normal)
                            }
                            
                        case .failure(_):
                            DispatchQueue.main.async {
                                self.showErrorMessage(message: "Не получилось добавить товар в корзину")
                            }
                        }
                }
            }
        } else {
            login(delegate: self)
        }
    }
    
}

extension ProductViewController: NeedLoginDelegate {
    // Очистка флагов для отслеживания какая кнопка нажата
    func willDisappear() {
        isAddReviewClicked = false
        isAddToCartClicked = false
    }
    
    func didReloadData() {
        if isAddReviewClicked {
            let addReview = app.getScreenPage(storyboard: "Reviews", identifier: "addReviewPage")
            present(addReview, animated: true)
        }
        
        if isAddToCartClicked {
            // Если на текущей странице есть товар, то его можно добавить
            if let pID = productID,
                let uID = app.session.userInfo?.idUser {
                    basketFabric.addProductToBasketBy(productId: pID, userId: uID, quantity: 1) { [weak self] response in
                        guard let self = self else { return }
                        
                        switch response.result {
                        case .success(_):
                            DispatchQueue.main.async {
                                self.btnAddToBasket.setTitle("В корзине", for: .normal)
                            }
                            
                        case .failure(_):
                            DispatchQueue.main.async {
                                self.showErrorMessage(message: "Не получилось добавить товар в корзину")
                            }
                        }
                }
            }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        reviewList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblReviewsList.dequeueReusableCell(withIdentifier: "productViewCell") as? ProductReviewCell else {
            preconditionFailure()
        }
        
        cell.configureWith(review: reviewList[indexPath.section])
            
        return cell
    }
}
