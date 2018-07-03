//
//  TakePhotoDocument.swift
//  idtp
//
//  Created by Apple on 22.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit

class TakePhotoDocument: TakePhoto {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = editingParticipant!.getPhotoWith(typeValue: photoTypeValue!) {
            imageView.image = DataManager.getImageFromCash(pathName: "Images", fileName: photo.fileName!)!
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
        
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        
        var imageHeight = CGFloat.init(100)
        if imageView.image != nil {
            let prop = view.frame.width / imageView.image!.size.width
            imageHeight = imageView.image!.size.height * prop
        }
        
        imageView.heightAnchor.constraint(equalToConstant:
            imageHeight).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        //imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30).isActive = true
        
        buttonAdd.heightAnchor.constraint(equalToConstant: 45).isActive = true
        buttonAdd.widthAnchor.constraint(equalToConstant: 210).isActive = true
        buttonAdd.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        buttonAdd.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        super.updateViewConstraints()
    }
    
    func changeImageExistance(){
        if imageView.image != nil {
            labelNoContent.isHidden = true
            buttonAdd.isHidden = true
            imageView.isHidden = false
        } else {
            labelNoContent.isHidden = false
            buttonAdd.isHidden = false
            imageView.isHidden = true
        }
    }
}
