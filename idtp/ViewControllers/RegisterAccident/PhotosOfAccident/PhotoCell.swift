//
//  PhotoCell.swift
//  idtp
//
//  Created by Apple on 26.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    var imageViewIndicator: UIImageView = {
        var imageViewIndicator = UIImageView()
        imageViewIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageViewIndicator.image = #imageLiteral(resourceName: "Checkmark")
        return imageViewIndicator
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel?.numberOfLines = 2
        self.addSubview(imageViewIndicator)
        self.addSubview(textLabel!)
        self.accessoryType = .disclosureIndicator
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        self.removeConstraints(self.constraints)
        
        textLabel!.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        textLabel!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 7).isActive = true
        
        imageViewIndicator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -38).isActive = true
        imageViewIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageViewIndicator.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageViewIndicator.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        super.updateConstraints()
    }
}
