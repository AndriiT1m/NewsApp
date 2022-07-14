//
//  SettingViewController.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 17.06.2022.
//

import UIKit

class MenuViewController: UIViewController {
    
    private var country: String = "us"
    private var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        configureTableView()
    }

    private func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTableCell.self, forCellReuseIdentifier: MenuTableCell.reuseId)
        view.addSubview(tableView)
        
        tableView.frame = view.frame
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        tableView.backgroundColor = .darkGray

    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuModel.allCases.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            country = "au"
        case 1:
            country = "ca"
        case 2:
            country = "jp"
        case 3:
            country = "ua"
        case 4:
            country = "us"
        case 5:
            country = "de"
        case 6:
            country = "cz"
        case 7:
            country = "it"
        case 8:
            country = "fr"
        case 9:
            country = "mx"
        case 10:
            country = "cn"
        case 11:
            country = "pl"
        case 12:
            country = "br"
        case 13:
            country = "se"
        case 14:
            country = "in"
            
        default:
            break
        }
        
        UserDefaults.standard.set(country, forKey: "country")
        UserDefaults.standard.synchronize()

        NotificationCenter.default.post(name: NSNotification.Name("restatrt"), object: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableCell.reuseId) as! MenuTableCell
        let menuLable = MenuModel(rawValue: indexPath.row)
        cell.mayLable.text = menuLable?.description
        return cell
    }
}
