//
//  SimpleText.swift
//  idtp
//
//  Created by Apple on 05.04.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit

class SimpleText: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    var text: String?
    var attributtedText: NSAttributedString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButtonItem.target = self
        doneButtonItem.action = #selector(self.doneAction)
        
        textView.isScrollEnabled = false
        
        if text == nil {
            textView.attributedText = attributtedText
        } else {
            textView.text = text
        }
        
        textView.isScrollEnabled = true
    }
    
    @objc func doneAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
