//
//  CheckingAccident.swift
//  idtp
//
//  Created by Apple on 26.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import SVProgressHUD

class CheckingAccident: UIViewController, ProgressDelegate {
    
    var checkingAccident: Accident?
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var currentTask: URLSessionDataTask?
    
    @IBOutlet weak var labelPhotoNumber: UILabel!
    @IBOutlet weak var labelCountOfSentPhotos: UILabel!
    @IBOutlet weak var buttonTrySendImagesAgain: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkingAccident = AccidentService.getEditingAccident()
        ProgressHandler.shared.delegate = self
        
        buttonTrySendImagesAgain.addTarget(self,
                                           action: #selector(sendPhotosIfNeed),
                                           for: .touchUpInside)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationProcessed),
            name: .notificationProcessed,
            object: nil)
        
        updateCountOfSentPhotosLabel()
        sendPhotosIfNeed()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //currentTask?.cancel()
    }
    
    @objc func sendPhotosIfNeed() {
        buttonTrySendImagesAgain.isHidden = true
        if let unsentPhoto = self.checkingAccident!.getUnsentPhoto() {
            progressView.isHidden = false
            progressView.progress = 0
            self.send(photo: unsentPhoto)
        } else {
            progressView.isHidden = true
            self.labelPhotoNumber.text = "Все фото отправлены"
        }
    }
    
    func send(photo: Photo) {
        labelPhotoNumber.text = "Отправка фото: " + photo.type.title
        
        currentTask = APIService.shared().sendImage(
            accidentRegisterId: Int(checkingAccident!.registerId),
            photo: photo,
            completionHandler: {
                (code, error) in
                
                if let err = error as! APIErrors? {
                    if err != .cancelled {
                        self.labelPhotoNumber.text = "Ошибка при отправке изображений."
                        self.progressView.progress = 0
                        self.buttonTrySendImagesAgain.isHidden = false
                    }
                    return
                }
                
                if code! > 0 {
                    photo.isSent = true
                    self.updateCountOfSentPhotosLabel()
                }
                
                self.sendPhotosIfNeed()
        })
    }
    
    func progressChanged(forTaskWithId taskIdentifier: Int, value: Float) {
        if taskIdentifier == currentTask?.taskIdentifier {
            progressView.progress = value
        }
    }
    
    func updateCountOfSentPhotosLabel() {
        labelCountOfSentPhotos.text = "Отправлено:  \(checkingAccident!.countOfSentPhotos())\\\(checkingAccident!.countOfAllPhotos())"
    }
    
    @objc func notificationProcessed() {
        self.navigationController?.popToRootViewController(animated: false)
    }
}
