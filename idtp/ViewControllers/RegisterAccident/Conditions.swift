//
//  Conditions.swift
//  idtp
//
//  Created by Apple on 17.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit

class Conditions: UITableViewController {

    @IBOutlet weak var barButtonContinue: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barButtonContinue.target = self
        barButtonContinue.action = #selector(registerAction)

        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        barButtonContinue.isEnabled = false
        barButtonContinue.isEnabled = true
    }
    
    @objc func registerAction() {
        let nextStoryboard = UIStoryboard(name: "Editing", bundle: nil)
        let controller = nextStoryboard.instantiateInitialViewController()
        
        self.navigationController?.pushViewController(controller!, animated: true)
    }
}
