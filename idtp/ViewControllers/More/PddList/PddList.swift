//
//  PddList.swift
//  idtp
//
//  Created by Apple on 05.04.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import SVProgressHUD

typealias PddItem = (name: String, content: NSAttributedString?)

class PddList: UITableViewController {

    var items: [PddItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PddCell")
        
        loadData()
        
        self.tableView.tableFooterView = UIView()
    }
    
    func loadData() {
        items = ReferenceBookService.loadPddItems()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard items != nil else {
            return 0
        }
        
        return items!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PddCell", for: indexPath)

        cell.accessoryType = .disclosureIndicator
        cell.textLabel!.text = items![indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "SimpleText", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController() as! SimpleText
        
        nextVC.attributtedText = items![indexPath.row].content
        nextVC.navigationItem.title = items![indexPath.row].name
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
