//
//  ConfirmingAccident.swift
//  idtp
//
//  Created by Apple on 03.04.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SVProgressHUD

class ConfirmingAccident: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintScrollViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldParticipantACode: UITextField!
    @IBOutlet weak var textFieldParticipantBCode: UITextField!
    
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var barButtonSend: UIBarButtonItem!
    
    @IBOutlet weak var labelSmsStatus: UILabel!
    
    var confirmingAccident: Accident?
    
    var currentTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldParticipantACode.delegate = self
        textFieldParticipantBCode.delegate = self
        
        confirmingAccident = AccidentService.getEditingAccident()
        
        if confirmingAccident!.isSmsSent == false {
            sendSms()
        }
        
        buttonSend.addTarget(self,
                             action: #selector(sendFixProtocolAction),
                             for: .touchUpInside)
        barButtonSend.target = self
        barButtonSend.action = #selector(sendFixProtocolAction)
        
        scrollView.keyboardDismissMode = .interactive
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: .UIKeyboardWillChangeFrame,
                                               object: nil)
        
        addDoneButtonOnKeyboard()
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var needToScrollToEditingView = false
        
        if endFrame.origin.y >= UIScreen.main.bounds.size.height {
            self.constraintScrollViewBottom?.constant = 0
        } else {
            if self.constraintScrollViewBottom?.constant == 0 {
                needToScrollToEditingView = true
            }
            
            self.constraintScrollViewBottom?.constant = endFrame.size.height
        }
        
        self.view.layoutIfNeeded()
        
        if needToScrollToEditingView {
            if textFieldParticipantACode.isFirstResponder {
                scrollTo(view: textFieldParticipantACode)
            }
            
            if textFieldParticipantBCode.isFirstResponder {
                scrollTo(view: textFieldParticipantBCode!)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollTo(view: textField)
    }
    
    func scrollTo(view: UIView) {
        if scrollView.bounds.height < scrollView.contentSize.height {
            let pointForViewOnScrollView = scrollView.convert(view.frame.origin, to: nil)
            
            if pointForViewOnScrollView.y - 70 > 0 {
                scrollView.setContentOffset(CGPoint.init(x: 0, y: pointForViewOnScrollView.y - 70), animated: true)
            }
        }
    }
    
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.bounds.width, height: 50)))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Далее",
                                                    style: UIBarButtonItemStyle.plain,
                                                    target: self,
                                                    action: #selector(doneKeyboardButtonAction))
        done.tintColor = UIColor.white
        
        let items = [flexSpace, done]
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textFieldParticipantACode.inputAccessoryView = doneToolbar
        self.textFieldParticipantBCode.inputAccessoryView = doneToolbar
    }
    
    @objc func doneKeyboardButtonAction() {
        if textFieldParticipantACode.isFirstResponder {
            textFieldParticipantBCode.becomeFirstResponder()
        } else if textFieldParticipantBCode.isFirstResponder {
            self.view.endEditing(true)
            sendFixProtocolAction()
        }
    }
    
    func sendSms() {
        SVProgressHUD.show()
        
        currentTask = APIService.shared().sendTwoSms(phoneA:
            confirmingAccident!.participantOne!.driversPhone!,
                                                     phoneB:
            confirmingAccident!.participantTwo!.driversPhone!,
                                                     completionHandler:
            {
                result, error  in
                
                SVProgressHUD.dismiss()
                
                if let err = error as! APIErrors? {
                    if err != .cancelled {
                        SVProgressHUD.showError(withStatus: "Ошибка")
                    }
                    return
                }
                
                if result == 1 {
                    self.confirmingAccident!.isSmsSent = true
                    self.labelSmsStatus.text = "СМС коды для подтверждения отправлены."
                } else {
                    self.labelSmsStatus.text = "Ошибка при отправке СМС."
                }
        })
    }
    
    @objc func sendFixProtocolAction() {
        if let error = DataCheck.checkConfirmationInputs(textFieldParticipantACode.text!,
                                                         textFieldParticipantBCode.text!) {
            self.showError(error)
            return
        }
        
        SVProgressHUD.show()
        currentTask = APIService.shared().fixProtocol(accident: confirmingAccident!,
                                                      codeA: textFieldParticipantACode.text!,
                                                      codeB: textFieldParticipantBCode.text!,
                                                      completionHandler:
            {
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
                    self.showError("Не верный код")
                    return
                }
                
                self.confirmingAccident!.state = .done
                self.confirmingAccident!.registerId = Int32(responce!.code!)
                self.confirmingAccident!.gibddResponce = responce!.gibddResponce
                
                PersistenceService.saveContext()
                
                let storyboard = UIStoryboard(name: "SimpleText", bundle: nil)
                let nextVC = storyboard.instantiateInitialViewController() as! SimpleText
                
                nextVC.text = self.confirmingAccident!.gibddResponce
                nextVC.navigationItem.title = "Ответ от ГИБДД"
                nextVC.navigationItem.hidesBackButton = true
                
                self.navigationController?.pushViewController(nextVC, animated: true)
        })
    }
}
