//
//  NeedLoginViewController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 16.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class NeedLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("loaded")
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        print("Click")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
