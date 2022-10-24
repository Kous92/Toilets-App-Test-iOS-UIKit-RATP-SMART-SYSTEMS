//
//  Coordinator.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 16/10/2022.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    
    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController = UINavigationController()
    
    func start() {
        let initialViewController = HomeViewController()
        navigationController.navigationBar.barTintColor = UIColor(named: "ratp_jade_green")
        navigationController.navigationItem.title = "Accueil"
        navigationController.pushViewController(initialViewController, animated: false)
    }
}
