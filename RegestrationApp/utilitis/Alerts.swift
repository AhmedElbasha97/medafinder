//
//  Alerts.swift
//  RegestrationApp
//
//  Created by ahmedelbasha on 4/29/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//

import Foundation
import Foundation
import UIKit
extension UIViewController{
    func showAlert(title: String, massage: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(massage)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
