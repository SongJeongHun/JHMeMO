//
//  UIViewController+Alert.swift
//  JHMeMO
//
//  Created by 송정훈 on 2020/08/13.
//  Copyright © 2020 JH. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title:String = "알림", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction  = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert,animated: true,completion: nil)
        
    }
    
}
