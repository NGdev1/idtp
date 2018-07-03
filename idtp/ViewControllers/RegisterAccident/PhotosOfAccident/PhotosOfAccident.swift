//
//  PhotosOfAccident.swift
//  idtp
//
//  Created by Apple on 26.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit

class PhotosOfAccident: UITableViewController {
    
    var editingAccident : Accident?
    var photosNames = ["Спереди слева", "Спереди справа", "Сзади слева", "Сзади справа"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Фото ДТП"
        
        let buttonDoneItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(self.doneAction))
        self.navigationItem.rightBarButtonItem = buttonDoneItem
        
        tableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 2
        
        if editingAccident!.additionalPhotosRequired > 0 {
            numberOfSections += 1
        }
        
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Фотографии участника А"
        } else if section == 1{
            return "Фотографии участника Б"
        } else {
            return "Дополнительные фотографии"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 4
        } else {
            return Int(editingAccident!.additionalPhotosRequired)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        let currentParticipant = indexPath.section == 0 ? editingAccident!.participantOne : editingAccident!.participantTwo
        
        if currentParticipant!.getPhotoWith(typeValue: indexPath.row + 5) != nil {
            cell.imageViewIndicator.isHidden = false
        } else {
            cell.imageViewIndicator.isHidden = true
        }
        
        cell.textLabel!.text = photosNames[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVc = TakePhotoAccident()
        nextVc.editingParticipant = indexPath.section == 0 ? editingAccident!.participantOne : editingAccident!.participantTwo
        nextVc.title = indexPath.section == 0 ? "Участник А" : "Участник Б"
        nextVc.photoTypeValue = indexPath.row + 5
        navigationController!.pushViewController(nextVc, animated: true)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func doneAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
