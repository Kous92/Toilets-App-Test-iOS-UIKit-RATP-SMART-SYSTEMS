//
//  SplashScreenViewController.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 18/10/2022.
//

import Foundation
import UIKit

final class SplashScreenViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test technique RATP Smart Systems"
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Chargement en cours..."
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.style = .medium
        spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ratp_blue")
        buildViewHierarchy()
        setConstraints()
        
        let group = DispatchGroup()
        
        checkSavedData()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(loadingLabel)
        view.addSubview(loadingSpinner)
    }
    
    private func setConstraints() {
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loadingLabel.topAnchor.constraint(equalTo: loadingSpinner.bottomAnchor, constant: 60).isActive = true
        loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
}

extension SplashScreenViewController {
    func checkSavedData() {
        guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else {
            return
        }
        
        let group = DispatchGroup()
        group.enter()
        GPSService.shared.fetchLocation()
        group.leave()
        
        group.enter()
        if CoreDataService.sharedInstance.checkToilets(context: container.viewContext) == 0 {
            print("Pas de données, lancement du téléchargement.")
            syncData()
        } else {
            print("Données déjà sauvegardées, prêt pour le offline.")
        }
        group.leave()
        
        group.notify(queue: .main) { [weak self] in
            self?.loadingLabel.text = "Chargement terminé."
            self?.goToMainView()
        }
        
        /*
        DispatchQueue.main.async { [weak self] in
            self?.loadingLabel.text = "Chargement terminé."
            self?.goToMainView()
        }
         */
    }
    
    private func syncData() {
        let service = NetworkService()
        service.fetch { [weak self] (response: Result<DataOutput, APIError>) in
            switch response {
            case .success(let data):
                guard let toilets = data.records else {
                    print("ERREUR: Aucune donnée")
                    return
                }
                
                print("Toilettes récupérées: \(toilets.count)")
                print(toilets)
                
                DispatchQueue.main.async { [weak self] in
                    self?.loadingLabel.text = "Toilettes récupérées: \(toilets.count)"
                    print("Sauvegarde des données avec Core Data.")
                    CoreDataService.sharedInstance.saveData(with: toilets)
                    self?.loadingLabel.text = "Les données de \(toilets.count) toilettes sont sauvegardées."
                }
                
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
            }
        }
    }
    
    private func goToMainView() {
        let vc = TabBar()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SplashScreenViewControllerPreview: PreviewProvider {
    static var previews: some View {
        // Prévisualisation avec plusieurs simulateurs iPhone et iPad en light et dark mode
        ForEach(deviceNames, id: \.self) { deviceName in
            /*
            // Mode lumineux (light mode)
            UIViewControllerPreview {
                HomeViewController()
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.light)
            .previewDisplayName("\(deviceName) (Light)")
            .edgesIgnoringSafeArea(.all)
             */
            
            // Mode sombre (dark mode)
            UIViewControllerPreview {
                SplashScreenViewController()
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.dark)
            .previewDisplayName("\(deviceName) (Dark)")
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#endif
