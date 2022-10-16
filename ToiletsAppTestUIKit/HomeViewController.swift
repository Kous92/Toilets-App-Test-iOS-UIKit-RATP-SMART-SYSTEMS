//
//  HomeViewController.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 12/10/2022.
//

import UIKit

class HomeViewController: UIViewController {
    var dataOutput: DataOutput?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ToiletTableViewCell.self, forCellReuseIdentifier: "customCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = .blue
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .none
        buildViewHierarchy()
        setConstraints()
        
        getData()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension HomeViewController {
    func getData() {
        let service: APIService = NetworkService()
        service.fetch { [weak self] (response: Result<DataOutput, APIError>) in
            switch response {
            case .success(let data):
                print("SUCCÈS, nombre de toilettes: \(data.records?.count ?? 0)")
                self?.dataOutput = data
                
                print(data.records?.compactMap { $0.fields?.horaire })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataOutput?.records?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? ToiletTableViewCell else {
            return UITableViewCell()
        }
        
        if let toilet = dataOutput?.records?[indexPath.row].fields {
            cell.configure(with: ToiletViewModel(address: toilet.adresse ?? "", opening: toilet.horaire ?? "", reducedMobility: toilet.accesPmr ?? "", distance: "5 km"))
        }
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

let deviceNames: [String] = [
    "iPhone SE (3rd generation)",
    "iPhone 14 Pro",
    "iPad Pro (9.7-inch)"
]

@available(iOS 13.0, *)
struct ViewControllerPreview: PreviewProvider {
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
                HomeViewController()
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.dark)
            .previewDisplayName("\(deviceName) (Dark)")
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#endif
