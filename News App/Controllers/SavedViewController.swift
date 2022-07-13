//
//  SavedViewController.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 17.06.2022.
//

import UIKit
import SafariServices

class SavedViewController: UIViewController {
    
    private var activityViewController: UIActivityViewController? = nil
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var items = [NewsTableViewCellViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        cfgTableView()
        addSubView()
        addConstraintsSubView()
        getNews()
    }
    
    private func getNews() {
        let saveData = UserDefaults.standard.object(forKey: "SaveData") as? Data
        guard let saveData = saveData else { return }
        guard let item = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(saveData) as? [NewsTableViewCellViewModel] else {return}
        items = item
    }
    
    private func addSubView() {
        view.addSubview(tableView)
    }
    
    private func cfgTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SaveTableViewCell.self, forCellReuseIdentifier: SaveTableViewCell.rCell)
        tableView.rowHeight = 250
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func addConstraintsSubView() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
        
    }
    
    private func shareNews(with modelUrl: URL) {
        self.activityViewController = UIActivityViewController.init(activityItems: [modelUrl],
                                                                    applicationActivities: nil)
        self.present(self.activityViewController!, animated: true, completion: nil)
    }
    
}

extension SavedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let articles = items[indexPath.row]
        
        guard let url = URL(string: articles.url) else { return nil}
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let inspectAction =
            UIAction(title: NSLocalizedString("Share link", comment: ""),
                     image: UIImage(systemName: "link")) { action in
                self.shareNews(with: url)
            }
            
            let storeAction =
            UIAction(title: NSLocalizedString("Remove from saved", comment: ""),
                     image: UIImage(systemName: "bookmark.fill")) { [self] action in
                
                let defaults = UserDefaults.standard
                let item = self.items.indices[indexPath.row]
                
                items.remove(at: item)
                
                DispatchQueue.main.async { [self] in
                    getNews()
                    tableView.reloadData()
                }
                
                if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: items,
                                                                    requiringSecureCoding: false) {
                    defaults.set(saveData, forKey: "SaveData")
                    defaults.synchronize()
                }
            }
            return UIMenu(title: "", children: [inspectAction, storeAction])
        }
    }
    func tableViewStore(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let articles = items[indexPath.row]
        guard let url = URL(string: articles.url) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveTableViewCell.rCell)
                as? SaveTableViewCell else { fatalError() }
        
        cell.configure(with: items[indexPath.row])
    
        return cell
    }
}

