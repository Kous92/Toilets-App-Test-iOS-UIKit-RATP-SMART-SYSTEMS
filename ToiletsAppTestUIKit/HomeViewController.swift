//
//  HomeViewController.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 12/10/2022.
//

import UIKit
import CoreData
import CoreLocation

class HomeViewController: UIViewController {
    private var toilets = [Toilet]()
    private var filteredToilets = [Toilet]()
    var managedObjectContext: NSManagedObjectContext?
    private var pmrFilterActive = false
    
    private lazy var filterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    private lazy var reducedMobilityFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(setReducedMobilityFilter(_:)), for: .touchUpInside)
        button.setTitle("Accès PMR", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var distanceSortButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sortDistance(_:)), for: .touchUpInside)
        button.setTitle("Proximité", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ToiletTableViewCell.self, forCellReuseIdentifier: "customCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshToiletData(_:)), for: .valueChanged)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = .blue
        tableView.dataSource = self
        tableView.delegate = self
        // tableView.backgroundColor = .none
        tableView.backgroundColor = .darkGray
        buildViewHierarchy()
        setConstraints()
        // GPSService.shared.fetchLocation()
        
        getData()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(filterView)
        view.addSubview(tableView)
        filterView.addSubview(reducedMobilityFilterButton)
    }
    
    private func setConstraints() {
        filterView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        filterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        filterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        reducedMobilityFilterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        reducedMobilityFilterButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        reducedMobilityFilterButton.centerYAnchor.constraint(equalTo: filterView.centerYAnchor).isActive = true
        reducedMobilityFilterButton.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 10).isActive = true
    }
}

extension HomeViewController {
    
    func getData() {
        guard let context = managedObjectContext else {
            print("Erreur récupération toilettes")
            return
        }
        
        // Récupération avec CoreData
        if CoreDataService.sharedInstance.checkToilets(context: context) > 0 {
            print("Tentative avec Core Data")
            do {
                let toiletEntities = try ToiletEntity.fetchAllToilets(context: context)
                // print(toiletEntities)
                
                for toilet in toiletEntities {
                    toilets.append(
                        Toilet(fields:
                                Fields(
                                    horaire: toilet.horaires,
                                    accesPmr: toilet.accesPmr,
                                    arrondissement: Int(toilet.arrondissement),
                                    geoPoint2D: toilet.coordinates,
                                    adresse: toilet.adresse,
                                    type: toilet.type,
                                    urlFicheEquipement: toilet.urlFicheEquipement,
                                    gestionnaire: toilet.gestionnaire,
                                    source: toilet.source,
                                    relaisBebe: toilet.relaisBebe
                                )
                              )
                    )
                }
                
                filteredToilets = toilets
            } catch {
                print("Échec")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
            return
        }
        
        let service: APIService = NetworkService()
        service.fetch { [weak self] (response: Result<DataOutput, APIError>) in
            switch response {
            case .success(let data):
                self?.toilets = data.records ?? []
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
            }
        }
    }
}

extension HomeViewController {
    @objc private func refreshToiletData(_ sender: Any) {
        let service: APIService = NetworkService()
        service.fetch { [weak self] (response: Result<DataOutput, APIError>) in
            switch response {
            case .success(let data):
                self?.toilets = data.records ?? []
                self?.filteredToilets = data.records ?? []
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
            }
        }
    }
}

extension HomeViewController {
    @objc func setReducedMobilityFilter(_ sender: Any) {
        if pmrFilterActive == false {
            reducedMobilityFilterButton.backgroundColor = .red
            pmrFilterActive = true
        } else {
            reducedMobilityFilterButton.backgroundColor = .blue
            pmrFilterActive = false
        }
        
        setPmrFilter()
    }
    
    private func setPmrFilter() {
        if pmrFilterActive == true {
            filteredToilets = toilets.filter { $0.fields?.accesPmr == "Oui" }
        } else {
            filteredToilets = toilets
        }
        
        tableView.reloadData()
    }
    
    @objc func sortDistance(_ sender: Any) {
        
    }
}

extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("Toilettes: \(toilets.count)")
        return filteredToilets.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? ToiletTableViewCell else {
            return UITableViewCell()
        }
        
        let toilet = filteredToilets[indexPath.row].fields
        if let coordinates = toilet?.geoPoint2D {
            let toiletPosition = CLLocation(latitude: coordinates.first!, longitude: coordinates.last!)
            var distanceOutput = "??"
            
            print("-> Récupération de la distance")
            if let distance = GPSService.shared.getActualPosition()?.distance(from: toiletPosition) {
                distanceOutput = distance < 1000 ? "\(distance) m" : "\(String(format:"%.02f", distance / 1000)) km"
                
                print(" -> Succès: \(distance)")
            } else {
                print(" -> Échec")
            }
            
            cell.configure(with: ToiletViewModel(address: toilet?.adresse ?? "Adresse indisponible", opening: toilet?.horaire ?? "Horaires indisponibles", reducedMobility: toilet?.accesPmr ?? "Non", distance: distanceOutput))
        } else {
            cell.configure(with: ToiletViewModel(address: toilet?.adresse ?? "Adresse indisponible", opening: toilet?.horaire ?? "Horaires indisponibles", reducedMobility: toilet?.accesPmr ?? "Non", distance: "??"))
        }
        
        
        
        /*
         cell.configure(with: ToiletViewModel(address: "115 avenue des Champs Élysées, 75008 Paris", opening: "24h / 24h", reducedMobility: "Oui", distance: "10 km"))
         */
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

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
                let vc = HomeViewController()
                guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else {
                    return vc
                }
                vc.managedObjectContext = container.viewContext
                return vc
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.dark)
            .previewDisplayName("\(deviceName) (Dark)")
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#endif
