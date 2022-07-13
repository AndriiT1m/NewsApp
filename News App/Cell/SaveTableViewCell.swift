//
//  SaveTableViewCell.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 24.06.2022.
//

import UIKit

class SaveTableViewCell: UITableViewCell {
    
    static var rCell = "TableViewCell"
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.shadowRadius = 7
        iv.layer.shadowOffset = CGSize(width: 4, height: 4)
        iv.layer.shadowOpacity = 0.2
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    let title: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "TimesNewRomanPSMT", size: 18)
        lable.numberOfLines = 5
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        addSubview(title)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            iconImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            iconImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 0),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 25
        self.layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 7, height: 7)
        self.clipsToBounds = false
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        iconImageView.image = UIImage(systemName: "newspaper")
        title.text = viewModel.title
        
//        image
        if let data = viewModel.imageData {
            iconImageView.image = UIImage(data: data)
        } else if let url = viewModel.imgUrl {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.iconImageView.image = UIImage(data: data)
                }
            }.resume()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
