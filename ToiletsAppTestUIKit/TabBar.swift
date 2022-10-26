//
//  TabBar.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 18/10/2022.
//

import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = UIColor(named: "ratp_jade_green")
        tabBar.tintColor = .white
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let home = ToiletListViewController()
        let map = ToiletMapViewController()
        guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else {
            return
        }
        
        home.viewModel = ToiletListViewModel(service: ToiletDataService())
        map.managedObjectContext = container.viewContext
        
        self.viewControllers = [
            createNavController(for: home, title: "Liste des toilettes", image: UIImage(systemName: "list.dash")!),
            createNavController(for: map, title: "Carte des toilettes", image: UIImage(systemName: "map")!)
        ]
    }
    
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "ratp_blue")
        navController.navigationBar.standardAppearance = appearance;
        navController.navigationBar.scrollEdgeAppearance = navController.navigationBar.standardAppearance
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
}
