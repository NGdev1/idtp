//
//  Sending.swift
//  idtp
//
//  Created by Apple on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class Sending: UIViewController, BEMCheckBoxDelegate {
    
    @IBOutlet weak var barButtonSend: UIBarButtonItem!
    @IBOutlet weak var checkboxPermission: BEMCheckBox!
    
    var sendingAccident: Accident?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendingAccident = AccidentService.getEditingAccident()
        
        barButtonSend.target = self
        barButtonSend.action = #selector(send)
        
        checkboxPermission.delegate = self
        checkboxPermission.onFillColor = ColorHelper.color(for: .baseTintColor)
        checkboxPermission.onCheckColor = UIColor.white
        checkboxPermission.boxType = .square
        checkboxPermission.onAnimationType = .fill
        checkboxPermission.offAnimationType = .fill
        
        barButtonSend.isEnabled = false
    }
    
    @objc func send() {
        guard checkboxPermission.on else {
            return
        }
        
        SVProgressHUD.show()
        
        let deviceId = Device.getDeviceId()
        let token = Messaging.messaging().fcmToken!
        
        let _ = APIService.shared().sendForChecking(accident: sendingAccident!, deviceId: deviceId, tokenFCM: token, completionHandler: {
            (responce: (code: Int?, gibddResponce: String?)?, error) in
            
            SVProgressHUD.dismiss()
            
            if let err = error as! APIErrors? {
                if err == .noConnection {
                    self.showError("Не удалось установить соединение")
                } else {
                    self.showError("Произошла ошибка")
                }
                return
            }
            
            if responce?.code == 0 {
                self.showError("Не удалось установить соединение")
                return
            }
            
            self.sendingAccident!.state = .checking
            self.sendingAccident!.registerId = Int32(responce!.code!)
            self.sendingAccident!.gibddResponce = responce!.gibddResponce
            
            PersistenceService.saveContext()
            
            let nextStoryboard = UIStoryboard(name: "CheckingAccident", bundle: nil)
            let controller = nextStoryboard.instantiateInitialViewController()
            
            controller!.navigationItem.hidesBackButton = true
            
            self.navigationController?.pushViewController(controller!, animated: true)
            
            SVProgressHUD.dismiss()
        })
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        barButtonSend.isEnabled = checkBox.on
    }
}
