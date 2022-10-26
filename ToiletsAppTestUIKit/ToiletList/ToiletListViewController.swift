//
//  ToiletListViewController.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 12/10/2022.
//

import UIKit
import CoreData
import CoreLocation
import Combine

class ToiletListViewController: UIViewController {
    private var pmrFilterActive = false
    private var sortDistanceActive = false
    var viewModel: ToiletListViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var filterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
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
        button.setTitle("Plus proches", for: .normal)
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
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .medium
        spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewHierarchy()
        setConstraints()
        setBindings()
        getData()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(filterView)
        view.addSubview(tableView)
        view.addSubview(loadingSpinner)
        filterView.addSubview(reducedMobilityFilterButton)
        filterView.addSubview(distanceSortButton)
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
        
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        reducedMobilityFilterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        reducedMobilityFilterButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        reducedMobilityFilterButton.centerYAnchor.constraint(equalTo: filterView.centerYAnchor).isActive = true
        reducedMobilityFilterButton.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 10).isActive = true
        
        distanceSortButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        distanceSortButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        distanceSortButton.centerYAnchor.constraint(equalTo: filterView.centerYAnchor).isActive = true
        distanceSortButton.leadingAnchor.constraint(equalTo: reducedMobilityFilterButton.trailingAnchor, constant: 10).isActive = true
    }
    
    private func setBindings() {
        viewModel?.isLoadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingSpinner.startAnimating()
                    self?.loadingSpinner.isHidden = false
                    self?.tableView.isHidden = true
                }
            }.store(in: &subscriptions)
        
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("OK: terminé")
                case .failure(let error):
                    print("Erreur reçue: \(error.rawValue)")
                }
            } receiveValue: { [weak self] updated in
                self?.loadingSpinner.stopAnimating()
                
                if updated {
                    self?.tableView.reloadData()
                    self?.tableView.isHidden = false
                } else {
                    print("Pas de contenu")
                }
            }.store(in: &subscriptions)
    }
}

extension ToiletListViewController {
    func getData() {
        print("ToiletListViewModel lancé (init)")
        viewModel?.getData()
    }
}

extension ToiletListViewController {
    @objc private func refreshToiletData(_ sender: Any) {
        print("ToiletListViewModel lancé (refresh)")
        viewModel?.getData()
    }
}

extension ToiletListViewController {
    @objc func setReducedMobilityFilter(_ sender: Any) {
        if pmrFilterActive == false {
            reducedMobilityFilterButton.backgroundColor = UIColor(named: "ratp_jade_green")
            pmrFilterActive = true
        } else {
            reducedMobilityFilterButton.backgroundColor = .blue
            pmrFilterActive = false
        }
        
        viewModel?.filterPmrData(isEnabled: pmrFilterActive)
    }
    
    @objc func sortDistance(_ sender: Any) {
        if sortDistanceActive == false {
            distanceSortButton.backgroundColor = UIColor(named: "ratp_jade_green")
            sortDistanceActive = true
        } else {
            distanceSortButton.backgroundColor = .blue
            sortDistanceActive = false
        }
        
        viewModel?.sortByDistance(isEnabled: sortDistanceActive)
    }
}

extension ToiletListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filteredToiletViewModels.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? ToiletTableViewCell else {
            return UITableViewCell()
        }
        
        if let viewModel = viewModel?.filteredToiletViewModels[indexPath.row] {
            cell.configure(with: viewModel)
        }
        
        return cell
    }
}

extension ToiletListViewController: UITableViewDelegate {
    
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
                let vc = ToiletListViewController()
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
