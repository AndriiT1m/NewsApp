//
//  NewsTableViewCell.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 18.06.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    static var idCell = "NewsTableViewCell"
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.shadowRadius = 7
        iv.layer.shadowOffset = CGSize(width: 4, height: 4)
        iv.layer.shadowOpacity = 0.2
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let title: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        lable.numberOfLines = 2
        lable.text = ""
        return lable
    }()
    
    let desctiption: UILabel = {
        let lable = UILabel()
        lable.textColor = .darkGray
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "TimesNewRomanPSMT", size: 17)
        lable.numberOfLines = 4
        lable.text = ""
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        addSubview(title)
        addSubview(desctiption)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),
            iconImageView.widthAnchor.constraint(equalToConstant: 120),
        ])
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            title.widthAnchor.constraint(equalToConstant: 220)
        ])
        
        NSLayoutConstraint.activate([
            desctiption.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            desctiption.topAnchor.constraint(equalTo: topAnchor, constant: 35),
            desctiption.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20),
            desctiption.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 6/10, constant: 5)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 15
        self.layer.shadowRadius = 9
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 3, height: 3)
        self.clipsToBounds = false
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        iconImageView.image = UIImage(systemName: "newspaper")
        title.text = viewModel.title
        desctiption.text = viewModel.desctiption
        
        //image
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


