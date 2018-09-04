//
//  RegisterAccident.swift
//  idtp
//
//  Created by Apple on 17.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import SVProgressHUD

class Editing: UITableViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    @IBOutlet weak var labelCarOne: UILabel!
    @IBOutlet weak var labelCarTwo: UILabel!
    
    @IBOutlet weak var labelPlace: UILabel!
    @IBOutlet weak var labelPhotos: UILabel!
    
    var editingAccident : Accident?
    
    override func viewDidLoad() {
        
        editingAccident = AccidentService.getEditingAccident()
        
        if editingAccident == nil {
            editingAccident = AccidentService.createAccident()
            editingAccident!.state = .editing
        }
        
        self.tableView.tableFooterView = UIView()
        
        dateTimePicker.isHidden = true
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setAccidentAttributesToCells()
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        doneButtonItem.isEnabled = false
        doneButtonItem.isEnabled = true
        
        PersistenceService.saveContext()
    }
    
    func setAccidentAttributesToCells() {
        if editingAccident!.place != nil {
            labelPlace.text = editingAccident!.place?.placeFull
            self.labelPlace.textColor = UIColor.black
        }
        
        if editingAccident!.dateTime != nil {
            dateTimePicker.setDate(Date(timeIntervalSince1970: editingAccident!.dateTime!.timeIntervalSince1970), animated: false)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YYYYг., HH:mm"
            
            labelDateTime.text = dateFormatter.string(from: dateTimePicker.date)
        } else {
            dateTimePickerChanged(self)
        }
        
        labelCarOne.text = " "
        if let participantOnePhone = editingAccident!.participantOne!.driversPhone {
            if !participantOnePhone.isEmpty {
                labelCarOne.text = "+7 " + participantOnePhone
            }
        }
        
        labelCarTwo.text = " "
        if let participantTwoPhone = editingAccident!.participantTwo!.driversPhone {
            if !participantTwoPhone.isEmpty {
                labelCarTwo.text = "+7 " + participantTwoPhone
            }
        }
        
        let countOfPhotos = editingAccident!.countOfAccidentPhotos()
        let allPhotos = 12
        if countOfPhotos != 0 {
            labelPhotos.text = "\(countOfPhotos)/\(allPhotos) Фото"
            labelPhotos.textColor = UIColor.black
        } else {
            labelPhotos.text = "Сделать фотографии"
            labelPhotos.textColor = UIColor.gray
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if let error = DataCheck.checkAccident(editingAccident!) {
            self.showError(error)
            return
        }
        
        self.performSegue(withIdentifier: "Sending", sender: self)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.askUser("Удалить оформление?",
                     actionNo: { _ in
                        
        },
                     actionYes: { _ in
                        
                        AccidentService.delete(accident: self.editingAccident!)
                        self.navigationController?.popViewController(animated: true)
                        
        })
    }
    
    @IBAction func dateTimePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYYг., HH:mm"
        
        labelDateTime.text = dateFormatter.string(from: dateTimePicker.date)
        editingAccident?.dateTime = NSDate(timeIntervalSince1970: dateTimePicker.date.timeIntervalSince1970)
    }
}

//Table View
extension Editing {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dateTimePicker.isHidden && indexPath.section == 1 && indexPath.row == 1 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let nextStoryboard = UIStoryboard(name: "GetLocation", bundle: nil)
            let controller = nextStoryboard.instantiateInitialViewController() as? GetLocation
            
            controller?.editingAccident = editingAccident
            controller?.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(controller!, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            toggleDatepicker()
        } else if indexPath.section == 2 || indexPath.section == 3 {
            let nextStoryboard = UIStoryboard(name: "Participant", bundle: nil)
            let controller = nextStoryboard.instantiateInitialViewController() as? ParticipantViewController
            
            controller?.editingAccident = self.editingAccident
            if indexPath.section == 2 {         //Participant One (A)
                controller?.editingParticipant = editingAccident!.participantOne
                controller?.editingParticipantNumber = 0
            } else {                            //Participant Two (B)
                controller?.editingParticipant = editingAccident!.participantTwo
                controller?.editingParticipantNumber = 1
            }
            
            self.navigationController?.pushViewController(controller!, animated: true)
        } else if indexPath.section == 4 {
            let nextVC = PhotosOfAccident(style: .grouped)
            
            nextVC.editingAccident = self.editingAccident
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func toggleDatepicker() {
        dateTimePicker.isHidden = !dateTimePicker.isHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
