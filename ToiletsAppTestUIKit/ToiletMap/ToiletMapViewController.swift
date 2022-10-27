//
//  ToiletMapViewController.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 18/10/2022.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import Combine

class ToiletMapViewController: UIViewController {
    private var toilets = [Toilet]()
    var managedObjectContext: NSManagedObjectContext?
    var viewModel: ToiletMapViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        map.showsUserLocation = true
        return map
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
        view.addSubview(loadingSpinner)
        view.addSubview(mapView)
    }
    
    private func setConstraints() {
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setBindings() {
        viewModel?.isLoadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingSpinner.startAnimating()
                    self?.loadingSpinner.isHidden = false
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
                    self?.mapView.isHidden = false
                    self?.initAnnotations()
                } else {
                    print("Pas de contenu")
                }
            }.store(in: &subscriptions)
    }
}

extension ToiletMapViewController {
    private func initData() {
        
    }
    
    func getData() {
        print("ToiletMapViewModel lancé (init)")
        viewModel?.getData()
    }
    
    private func initMap() {
        // Le centre de Paris (par rapport à sa surface)
        let location = CLLocation(latitude: 48.8564072, longitude: 2.342653)
        let regionRadius = 15000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: CLLocationDistance(regionRadius), longitudinalMeters: CLLocationDistance(regionRadius))
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension ToiletMapViewController: MKMapViewDelegate {
    private func initAnnotations() {
        viewModel?.toiletViewModels.forEach{ toilet in
            let annotation = MKPointAnnotation()
            annotation.title = toilet.address
            annotation.subtitle = toilet.opening
            
            guard let coordinates = toilet.getCoordinates() else {
                print("Erreur, pas de coordonnées")
                return
            }
            
            annotation.coordinate = coordinates
            mapView.addAnnotation(annotation)
        }
        
        initMap()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MapViewControllerPreview: PreviewProvider {
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
                let vc = ToiletMapViewController()
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
