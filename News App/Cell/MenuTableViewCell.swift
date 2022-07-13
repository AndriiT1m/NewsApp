//
//  MenuTableViewCell.swift
//  Sushi App
//
//  Created by Andrii Tymoshchuk on 16.06.2022.
//  Copyright © 2022 Алексей Пархоменко. All rights reserved.
//

import UIKit

class MenuTableCell: UITableViewCell {
    static var reuseId = "MenuTableViewCell"
    
    let mayLable: UILabel = {
        let lable = UILabel()
        lable.text = "Setting"
        lable.textColor = .white
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: 20)
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(mayLable)
        
        backgroundColor = .clear
        mayLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mayLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
