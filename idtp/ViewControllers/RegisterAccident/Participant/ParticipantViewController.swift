//
//  Participant.swift
//  idtp
//
//  Created by Apple on 20.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import CoreData

class ParticipantViewController: UITableViewController {
    
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var segmentedControlStatus: UISegmentedControl!
    
    @IBOutlet weak var photoIndicator1: UIImageView!
    @IBOutlet weak var photoIndicator2: UIImageView!
    @IBOutlet weak var photoIndicator3: UIImageView!
    @IBOutlet weak var photoIndicator4: UIImageView!
    @IBOutlet weak var photoIndicator5: UIImageView!
    
    var photoIndicators = [UIImageView]()
    
    var editingParticipant : Participant?
    var editingAccident : Accident?
    var editingParticipantNumber = 0
    var selectedPhone : String?
    
    var childVcDelegate : SecondVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoIndicators.append(photoIndicator1)
        photoIndicators.append(photoIndicator2)
        photoIndicators.append(photoIndicator3)
        photoIndicators.append(photoIndicator4)
        photoIndicators.append(photoIndicator5)
        
        addDoneButtonOnKeyboard()
        textFieldPhone.delegate = self
        
        self.textFieldPhone!.text = editingParticipant!.driversPhone
        self.segmentedControlStatus.selectedSegmentIndex = Int(editingParticipant!.stateValue)
        
        self.tableView.keyboardDismissMode = .interactive
        self.tableView.tableFooterView = UIView()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.bounds.width, height: 50)))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Далее", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ParticipantViewController.textFieldDoneButtonAction))
        done.tintColor = UIColor.white
        
        let items = [flexSpace, done]
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textFieldPhone.inputAccessoryView = doneToolbar
    }
    
    @objc func textFieldDoneButtonAction(){
        self.textFieldPhone.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in 0...4 {
            if editingAccident!.getPhotoWith(typeValue: i + editingParticipantNumber * 5) == nil {
                photoIndicators[i].isHidden = true
            } else {
                photoIndicators[i].isHidden = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        PersistenceService.saveContext()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        saveData()
        
        self.childVcDelegate?.didFinishSecondVC(self)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func saveData() {
        if let error = DataCheck.checkDriversPhone(textFieldPhone.text!) {
            self.showError(error)
            return
        } else {
            editingParticipant!.driversPhone = textFieldPhone.text
        }
        editingParticipant!.stateValue = Int32(segmentedControlStatus!.selectedSegmentIndex)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 2 {
            return
        }
        
        let nextVC = TakePhotoDocument()
        
        nextVC.photoTypeValue = indexPath.row + editingParticipantNumber * 5
        nextVC.title = PhotoType(rawValue: Int32(nextVC.photoTypeValue!))!.title
        nextVC.editingAccident = self.editingAccident
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ParticipantViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
        textField.text = newText.applyPatternOnNumbers(pattern: "(###) ###-####", replacmentCharacter: "#")
        
        return false
    }
}
