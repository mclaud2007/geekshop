//
//  BasketViewController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 18.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class BasketViewController: BaseViewController, TrackableMixin {
   
    @IBOutlet weak var tblBasket: UITableView! {
        didSet {
            tblBasket.delegate = self
            tblBasket.dataSource = self
        }
    }
    
    @IBOutlet weak var lblGoodsCount: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblBasketIsEmpty: UILabel!
    @IBOutlet weak var lblGoodsCountTitle: UILabel!
    @IBOutlet weak var lblTotalPriceTitle: UILabel!
    
    var basket: GetBasketResult?
    var items: [BasketContents] = []
    let basketFabric = RequestFactory().makeBasketFactory()
        
    override func viewWillAppear(_ animated: Bool) {
        // Проверим авторизацию пользователя
        if !isNeedLogin {
            // Загружаем корзину
            loadBasket()
            
        } else {
            toggleLables(hide: true)
            login(delegate: self)

        }
    }
    
    func toggleLables(hide: Bool = true) {
        tblBasket.isHidden = hide
        lblTotalPrice.isHidden = hide
        lblTotalPriceTitle.isHidden = hide
        lblGoodsCount.isHidden = hide
        lblGoodsCountTitle.isHidden = hide
        btnPay.isHidden = hide
        btnClear.isHidden = hide
    }
    
    private func loadBasket() {
        if let uID = userId {
            basketFabric.getBasketBy(userId: uID) { response in
                switch response.result {
                case let .success(basketResult):
                    DispatchQueue.main.async {
                        self.basket = basketResult
                        self.items = basketResult.contents
                        
                        self.tblBasket.reloadData()
                        
                        if basketResult.countGoods > 0 {
                            self.toggleLables(hide: false)
                            
                            self.lblTotalPrice.text = String(self.basket?.amount ?? 0)
                            self.lblGoodsCount.text = String(self.basket?.countGoods ?? 0)
                        } else {
                            self.lblBasketIsEmpty.isHidden = false
                            self.toggleLables(hide: true)
                        }
                    }
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Ошибка отображения корзины")
                    }
                }
            }
        } else {
            lblBasketIsEmpty.isHidden = false
            toggleLables(hide: true)
            
        }
    }
       
    private func cleanBasket() {
        if let uID = userId {
            basketFabric.clearBasketFrom(userId: uID) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(_):
                    self.track(.cleanBasket)
                    self.loadBasket()
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Ошибка очистки корзины")
                    }
                }
            }
        }
    }
    
    @IBAction func btnPayClicked(_ sender: Any) {
        if let uID = userId,
            let amount = basket?.amount {
            
            basketFabric.payOrderBy(userId: uID, paySumm: amount) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case let .success(payResult):
                    DispatchQueue.main.async {
                        self.track(.payBasket(param: ["PAYMENT_SUMMARY": amount]))
                        self.showErrorMessage(message: payResult.message ?? "Заказ оплачен", title: "Успех")
                    }
                    
                    // Очищаем корзину
                    self.cleanBasket()
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Ошибка оплаты заказа")
                    }
                }
            }
        }
    }
    
    @IBAction func btnClean(_ sender: Any) {
        cleanBasket()
    }

}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblBasket.dequeueReusableCell(withIdentifier: "basketCell") as? BasketCell else {
            assertionFailure("Can't dequeue reusable cell withIdentifier: basketCell")
            return UITableViewCell()
        }
        
        // Выводим строку с тоавром
        cell.configureWith(items[indexPath.row])
        
        return cell
    }
}

extension BasketViewController: NeedLoginDelegate {
    func didReloadData() {
        self.loadBasket()
    }
    
    func willDisappear() { }
        
}
