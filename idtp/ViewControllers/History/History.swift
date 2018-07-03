//
//  History.swift
//  idtp
//
//  Created by Apple on 17.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit

class History: UITableViewController {
    
    var items : [Accident]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "AccidentCell", bundle: nil), forCellReuseIdentifier: "AccidentCell")
        
        loadData()
        
        self.tableView.tableFooterView = UIView()
    }
    
    func loadData() {
        items = AccidentService.getFinishedAccidents()
        
        if items?.count == 0 {
            let labelNoContent = UILabel(frame: view.frame)
            labelNoContent.frame.size.height = 100
            labelNoContent.text = "Нет ДТП в истории"
            labelNoContent.textAlignment = .center
            labelNoContent.textColor = UIColor.gray
            
            self.tableView.tableHeaderView = labelNoContent
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard items != nil else {
            return 0
        }
        
        return items!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AccidentCell")
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AccidentCell else {
            return
        }
        
        let accident = self.items![indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYYг., HH:mm"
        
        cell.labelDateTime.text = dateFormatter.string(from: accident.dateTime! as Date)
        cell.labelPlace.text = accident.place!.placeName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let accident = self.items![indexPath.row]
        
        let storyboard = UIStoryboard(name: "SimpleText", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController() as! SimpleText
        
        nextVC.text = accident.gibddResponce
        nextVC.navigationItem.title = "Ответ от ГИБДД"
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
