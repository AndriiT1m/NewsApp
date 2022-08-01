//
//  HomeViewController.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 17.06.2022.
//

import UIKit
import SafariServices

protocol HomeViewControllerDelegate: AnyObject {
    func toggleMenu()
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    static var shared: HomeViewController?
    private let networkDataFetcher = NetworkDataFetcher()
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Articles]()
    private var activityViewController: UIActivityViewController? = nil
    private var saveNews = [NewsTableViewCellViewModel]()
    
    private var dateLable: UILabel = {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEEE, d MMMM"
        
        var lable = UILabel()
        lable.text = dateFormatter.string(from: date).capitalized
        lable.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        lable.translatesAutoresizingMaskIntoConstraints = false
        
        return lable
    }()
    
    private var menuButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "globe.europe.africa.fill"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadFetcher),
                                               name: NSNotification.Name("restatrt"),
                                               object: nil)
        cfgTableView()
        addSubView()
        addConstraintsSubView()
        reloadFetcher()
        getNews()
        
        menuButton.addTarget(self, action: #selector(menuDidTapButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(showSV), for: .touchUpInside)
        ContainerViewController.search.searchBar.delegate = self
        
    }
    
    private func getNews() {
        let saveData = UserDefaultsHelper.getData(type: Data.self, forKey: .saveNews)

        guard let saveData = saveData else { return }
        guard let item = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(saveData)
                as? [NewsTableViewCellViewModel] else {return}
        saveNews = item
    }
    
    private func addSubView() {
        view.addSubview(dateLable)
        view.addSubview(menuButton)
        view.addSubview(saveButton)
        view.addSubview(tableView)
    }
    
    private func cfgTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self,
                           forCellReuseIdentifier: NewsTableViewCell.idCell)
        tableView.rowHeight = 150
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = true
    }
    
    private func addConstraintsSubView() {
        
        NSLayoutConstraint.activate([
            dateLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            dateLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.centerYAnchor.constraint(equalTo: dateLable.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            menuButton.heightAnchor.constraint(equalToConstant: 35),
            menuButton.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.centerYAnchor.constraint(equalTo: menuButton.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dateLable.bottomAnchor, constant: 15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
            
        ])
    }
    
    @objc func reloadFetcher() {
        networkDataFetcher.fetchNews() { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               desctiption: $0.description ?? "",
                                               url: $0.url,
                                               imgUrl: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func showSV() {
        let vc = SavedViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func shareNews(with modelUrl: URL) {
        self.activityViewController = UIActivityViewController.init(activityItems: [modelUrl],
                                                                    applicationActivities: nil)
        self.present(self.activityViewController!, animated: true, completion: nil)
    }
    
    @objc func menuDidTapButton() {
        delegate?.toggleMenu()
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let articles = viewModels[indexPath.row]
        
        guard let url = URL(string: articles.url) else { return nil}
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [self] suggestedActions in
            
            let inspectAction =
            UIAction(title: NSLocalizedString("Share link", comment: ""),
                     image: UIImage(systemName: "link")) { action in
                self.shareNews(with: url)
            }
            
            getNews()
            let isFavorite = saveNews.contains { item in
                item.url == articles.url
            }
            
            let title = isFavorite ? "Remove from saved" : "Save"
            let img = isFavorite ? "bookmark.fill" : "bookmark"
            
            let storeAction =
            UIAction(title: NSLocalizedString(title, comment: ""),
                     image: UIImage(systemName: img)) { action in
                
                let index = self.saveNews.firstIndex(where: {$0.url == articles.url})
                
                if isFavorite {
                    self.saveNews.remove(at: index!)
                } else {
                    self.saveNews.append(articles)
                }
                
                if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: self.saveNews,
                                                                    requiringSecureCoding: false) {
                    UserDefaultsHelper.setData(value: saveData, key: .saveNews)
                }
            }
            
            return UIMenu(title: "", children: [inspectAction, storeAction])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let articles = viewModels[indexPath.row]
        guard let url = URL(string: articles.url) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.idCell)
                as? NewsTableViewCell else { fatalError() }
        
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        networkDataFetcher.fetchSearchNews(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               desctiption: $0.description ?? "",
                                               url: $0.url,
                                               imgUrl: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
