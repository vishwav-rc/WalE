//
//  BaseViewController.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func showAlertWithMessage(message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
