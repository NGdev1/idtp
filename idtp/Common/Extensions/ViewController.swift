//
//  ViewController.swift
//  idtp
//
//  Created by Apple on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showError(_ message : String) {
        
        let alertController = UIAlertController(title: "", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Назад", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func askUser(_ question: String, actionNo: @escaping (UIAlertAction) -> Void, actionYes: @escaping (UIAlertAction) -> Void){
        let alertController = UIAlertController(title: question, message:
            "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Нет", style: UIAlertActionStyle.default, handler: actionNo))
        alertController.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.default, handler: actionYes))
        self.present(alertController, animated: true, completion: nil)
    }
}
