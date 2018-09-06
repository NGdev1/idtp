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
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Фотографии участника А"
        } else if section == 1 {
            return "Фотографии участника Б"
        } else if section == 2 {
            return "Дополнительные фотографии"
        } else {
            return "Фото заполненного бланка Извещения о ДТП"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 4
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
//        if indexPath.section == 3 {
//            return 60
//        } else {
//            return self.tableView.estimatedRowHeight
//        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        var photoTypeValue = 0
        if indexPath.section == 0 || indexPath.section == 1 {
            photoTypeValue = 10 + indexPath.section * 4 + indexPath.row
        } else if indexPath.section == 2 {
            photoTypeValue = 18 + indexPath.row
        } else if indexPath.section == 3 {
            photoTypeValue = 20 + indexPath.row
        }
        
        if editingAccident!.getPhotoWith(typeValue: photoTypeValue) != nil {
            cell.imageViewIndicator.isHidden = false
        } else {
            cell.imageViewIndicator.isHidden = true
        }
        
        cell.textLabel!.text = PhotoType(rawValue: Int32(photoTypeValue))!.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var nextVc: TakePhoto?
        
        var photoTypeValue = 0
        if indexPath.section == 0 || indexPath.section == 1 {
            nextVc = TakePhotoAccident()
            nextVc!.title = indexPath.section == 0 ? "Участник А" : "Участник Б"
            photoTypeValue = 10 + indexPath.section * 4 + indexPath.row
        } else if indexPath.section == 2 {
            nextVc = TakePhotoDocument()
            nextVc!.title = "Доп. Фото"
            photoTypeValue = 18 + indexPath.row
        } else if indexPath.section == 3 {
            nextVc = TakePhotoDocument()
            nextVc!.title = "Фото"
            indexPath.row == 0 ? (nextVc!.imageSample = #imageLiteral(resourceName: "dtpBlankSamplePage1")) : (nextVc!.imageSample = #imageLiteral(resourceName: "dtpBlankSamplePage2"))
            photoTypeValue = 20 + indexPath.row
        }
        
        nextVc!.editingAccident = self.editingAccident
        nextVc!.photoTypeValue = photoTypeValue
        navigationController!.pushViewController(nextVc!, animated: true)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func doneAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
