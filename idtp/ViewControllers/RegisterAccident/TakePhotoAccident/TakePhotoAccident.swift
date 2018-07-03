//
//  TakePhotoAccident.swift
//  idtp
//
//  Created by Apple on 26.02.2018.
//  Copyright © 2018 md. All rights reserved.
//


class TakePhotoAccident : TakePhoto {
    
    var imageDidSelected = false
    var labelPhotoDescription : UILabel = {
        var labelPhotoDescription = UILabel()
        labelPhotoDescription.translatesAutoresizingMaskIntoConstraints = false
        labelPhotoDescription.textAlignment = .center
        labelPhotoDescription.textColor = UIColor.gray
        return labelPhotoDescription
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.addSubview(labelPhotoDescription)
        
        setTemplateImageAndLabel()
        
        if let photo = editingParticipant!.getPhotoWith(typeValue: photoTypeValue!) {
            imageView.image = DataManager.getImageFromCash(pathName: "Images", fileName: photo.fileName!)!
            imageDidSelected = true
        } else {
            imageDidSelected = false
        }
        
        changeImageExistance()
        self.updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        self.view.clearConstraints()
        
        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        labelNoContent.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        labelNoContent.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        //labelNoContent!.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor, constant: 100).isActive = true
        
        if imageDidSelected {
            labelPhotoDescription.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        } else {
            labelPhotoDescription.topAnchor.constraint(equalTo: labelNoContent.bottomAnchor, constant: 20).isActive = true
        }
        labelPhotoDescription.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: labelPhotoDescription.bottomAnchor, constant: 30).isActive = true
        
        var imageHeight = CGFloat.init(324)
        var imageWidth = view.frame.width
        if imageDidSelected {
            let prop = view.frame.width / imageView.image!.size.width
            imageHeight = imageView.image!.size.height * prop
        } else {
            imageWidth = 271
        }
        
        imageView.heightAnchor.constraint(equalToConstant:
            imageHeight).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30).isActive = true
        
        buttonAdd.heightAnchor.constraint(equalToConstant: 45).isActive = true
        buttonAdd.widthAnchor.constraint(equalToConstant: 210).isActive = true
        buttonAdd.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonAdd.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -65).isActive = true
        
        super.updateViewConstraints()
    }
    
    func changeImageExistance(){
        if imageDidSelected {
            labelNoContent.isHidden = true
            buttonAdd.isHidden = true
        } else {
            labelNoContent.isHidden = false
            buttonAdd.isHidden = false
        }
    }
    
    func setTemplateImageAndLabel(){
        switch photoTypeValue! {
        case 5:
            imageView.image = #imageLiteral(resourceName: "CameraPosition1")
            labelPhotoDescription.text = "Фото спереди слева"
        case 6:
            imageView.image = #imageLiteral(resourceName: "CameraPosition2")
            labelPhotoDescription.text = "Фото спереди справа"
        case 7:
            imageView.image = #imageLiteral(resourceName: "CameraPosition3")
            labelPhotoDescription.text = "Фото сзади слева"
        default:
            imageView.image = #imageLiteral(resourceName: "CameraPosition4")
            labelPhotoDescription.text = "Фото сзади справа"
        }
    }
}

