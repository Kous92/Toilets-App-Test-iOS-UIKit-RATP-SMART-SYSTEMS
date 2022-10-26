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

class ToiletMapViewController: UIViewController {
    private var toilets = [Toilet]()
    var managedObjectContext: NSManagedObjectContext?
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        map.showsUserLocation = true
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewHierarchy()
        setConstraints()
        initMap()
        getData()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(mapView)
    }
    
    private func setConstraints() {
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ToiletMapViewController {
    private func initData() {
        
    }
    
    func getData() {
        guard let context = managedObjectContext else {
            print("Erreur récupération toilettes")
            return
        }
        
        /*
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
            } catch {
                print("Échec")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.initAnnotations()
            }
            return
        }
        
        let service: APIService = NetworkService()
        service.fetch { [weak self] (response: Result<DataOutput, APIError>) in
            switch response {
            case .success(let data):
                self?.toilets = data.records ?? []
                
                DispatchQueue.main.async { [weak self] in
                    self?.initAnnotations()
                }
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
            }
        }
         */
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
        toilets.forEach { toilet in
            let annotation = MKPointAnnotation()
            annotation.title = toilet.fields?.adresse ?? "Toilettes"
            
            guard let coordinates = toilet.fields?.geoPoint2D else {
                print("Erreur, pas de coordonnées")
                return
            }
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
            mapView.addAnnotation(annotation)
        }
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
