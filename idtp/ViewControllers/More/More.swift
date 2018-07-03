//
//  More.swift
//  idtp
//
//  Created by Apple on 17.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit

class More: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //О приложении
        if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "SimpleText", bundle: nil)
            let nextVC = storyboard.instantiateInitialViewController() as! SimpleText
            
            nextVC.attributtedText = ReferenceBookService.loadAboutText()
            nextVC.navigationItem.title = "О приложении"
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        //Правила ПДД
        } else if indexPath.row == 0 {
            let nextVC = PddList.init(style: .grouped)

            nextVC.navigationItem.title = "Правила ПДД"
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        //Статьи КоАП
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "SimpleText", bundle: nil)
            let nextVC = storyboard.instantiateInitialViewController() as! SimpleText
            
            nextVC.attributtedText = ReferenceBookService.loadKoapText()
            nextVC.navigationItem.title = "Статьи КоАП"
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        //Коды регионов
        } else if indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "SimpleText", bundle: nil)
            let nextVC = storyboard.instantiateInitialViewController() as! SimpleText
            
            nextVC.attributtedText = ReferenceBookService.loadRegionCodes()
            nextVC.navigationItem.title = "Коды регионов"
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        //Телефоны ГИБДД
        } else if indexPath.row == 3 {
            let storyboard = UIStoryboard(name: "SimpleText", bundle: nil)
            let nextVC = storyboard.instantiateInitialViewController() as! SimpleText
            
            nextVC.attributtedText = ReferenceBookService.loadGibddPhoneNumbers()
            nextVC.navigationItem.title = "Телефоны ГИБДД"
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        //При ДТП
        } else if indexPath.row == 4 {
            let storyboard = UIStoryboard(name: "SimpleText", bundle: nil)
            let nextVC = storyboard.instantiateInitialViewController() as! SimpleText
            
            nextVC.attributtedText = ReferenceBookService.loadDtpFaqText()
            nextVC.navigationItem.title = "При ДТП"
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    
}
