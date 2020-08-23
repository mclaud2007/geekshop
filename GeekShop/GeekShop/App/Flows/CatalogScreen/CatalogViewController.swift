//
//  CatalogViewController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 12.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController, TrackableMixin {
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView! 
    
    // MARK: Properties
    var catalogFactory = RequestFactory().makeCatalogFactory()
    var productList: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Каталог"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductViewCell", bundle: nil), forCellReuseIdentifier: "catalogCell")

        // Пытаемся получить список товаров
        catalogFactory.getProductsList { response in
            switch response.result {
            case .success(let catalogResult):
                DispatchQueue.main.async {
                    self.productList = catalogResult
                    self.tableView.reloadData()
                    
                    // Записываем событие "открыт каталог"
                    self.track(.openCatalogPage(param: ["TOTAL_GOODS": catalogResult.count]))
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: "Ошибка отображения каталога")
                }
            }
        }
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let productVC = AppManager.shared.getScreenPage(storyboard: "Catalog", identifier: "productDetailScreen") as? ProductViewController {
            productVC.productID = productList[indexPath.row].idProduct
            navigationController?.pushViewController(productVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "catalogCell", for: indexPath) as? ProductViewCell else {
            assertionFailure("Can't dequeue reusable cell withIdentifier: catalogCell")
            return UITableViewCell()
        }
        
        cell.configureWith(product: productList[indexPath.row])
        
        return cell
    }
    
}
