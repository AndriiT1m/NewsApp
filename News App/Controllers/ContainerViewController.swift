//
//  ContainerViewController.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 17.06.2022.
//

import UIKit

class ContainerViewController: UIViewController, HomeViewControllerDelegate {
    
    private var homeController = HomeViewController()
    private var menuVC = MenuViewController()
    private var savedVC = SavedViewController()
    private var isMove = false
    static let search = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cfgHomeViewController()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleMenu),
                                               name: NSNotification.Name("restatrt"),
                                               object: nil)
        
        self.navigationItem.searchController = ContainerViewController.search
        navigationItem.title = "NEWS"
        
    }
    
    //MARK: - HOME
    private func cfgHomeViewController() {
        view.addSubview(homeController.view)
        addChild(homeController)
        homeController.view.backgroundColor = .systemBackground
        homeController.delegate = self
    }
    //MARK: - MENU
    private func cfgMenuViewController() {
        menuVC.view.frame = view.bounds
        addChild(menuVC)
        view.insertSubview(menuVC.view, at: 0)
    }
    
    //MARK: - SAVED
    private func cfgSavedViewController() {
        savedVC.view.frame = view.bounds
        view.addSubview(savedVC.view)
        addChild(savedVC)
    }
    
    private func showMenuViewController(shouldMove: Bool) {
        if shouldMove {
            // show menu
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseInOut]){
                self.homeController.view.frame.origin.x -= self.homeController.view.frame.width / 2
                self.menuVC.view.frame.origin.x = self.homeController.view.frame.maxX
                self.navigationItem.searchController?.searchBar.isHidden = true
                self.navigationItem.title = ""
            } completion: { (finished) in
                
            }
        } else {
            //clouse menu
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut) {
                self.homeController.view.frame.origin.x = 0
                self.menuVC.view.frame.origin.x = 0
            } completion: { _ in
                self.navigationItem.searchController?.searchBar.isHidden = false
                self.navigationItem.title = "NEWS"
            }
        }
    }
    
    @objc func toggleMenu() {
        cfgMenuViewController()
        isMove = !isMove
        showMenuViewController(shouldMove: isMove)
    }
}
