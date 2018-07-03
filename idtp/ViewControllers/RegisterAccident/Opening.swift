//
//  Opening.swift
//  idtp
//
//  Created by Apple on 17.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit

class Opening: UIViewController {
    
    @IBOutlet weak var barButtonBegin: UIBarButtonItem!
    @IBOutlet weak var buttonBegin: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var editingAccident : Accident?
    
    override func viewDidLoad() {
        editingAccident = AccidentService.getEditingAccident()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if editingAccident != nil {
            changeInterfaceToContinue(accidentState: editingAccident!.state)
        } else {
            changeInterfaceToBegin()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        barButtonBegin.isEnabled = false
        barButtonBegin.isEnabled = true
    }
    
    func changeInterfaceToBegin(){
        buttonBegin.setTitle("Регистрация ДТП", for: .normal)
        buttonCancel.isHidden = true
    }
    
    func changeInterfaceToContinue(accidentState: AccidentState) {
        if accidentState == .confirming {
            buttonBegin.setTitle("Перейти к подтверждению", for: .normal)
        } else {
            buttonBegin.setTitle("Продолжить", for: .normal)
        }
        
        buttonCancel.isHidden = false
    }
    
    @IBAction func beginAction(_ sender: Any) {
        if editingAccident != nil {
            var storyboardName = "Editing"
            if editingAccident!.state == .checking {
                storyboardName = "CheckingAccident"
            } else if editingAccident!.state == .confirming {
                storyboardName = "ConfirmingAccident"
            }
            
            let nextStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let controller = nextStoryboard.instantiateInitialViewController()
            
            self.navigationController?.pushViewController(controller!, animated: true)
        } else {
            self.performSegue(withIdentifier: "beginRegistering", sender: self)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        self.askUser("Удалить оформление?",
                      actionNo: { _ in
                        
        },
                      actionYes: { _ in
                        
                        if self.editingAccident != nil {
                            AccidentService.delete(accident: self.editingAccident!)
                            self.editingAccident = nil
                            self.changeInterfaceToBegin()
                        }
                        
        })
        
    }
}
