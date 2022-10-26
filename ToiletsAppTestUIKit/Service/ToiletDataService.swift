//
//  ToiletDataService.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 17/10/2022.
//

import Foundation
import CoreData
import CoreLocation
import UIKit

final class ToiletDataService: APIService {
    private var toilets = [Toilet]()
    private let coreDataService: CoreDataService
    private let networkService: NetworkService
    private let gpsService: GPSService
    private var managedObjectContext: NSManagedObjectContext? = nil
    
    init() {
        self.coreDataService = CoreDataService()
        self.networkService = NetworkService()
        self.gpsService = GPSService()
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            self.managedObjectContext = container.viewContext
        }
        
        self.gpsService.fetchLocation()
    }
    
    func fetch(completion: @escaping (Result<[Toilet], APIError>) -> ()) {
        guard let managedObjectContext else {
            completion(.failure(.coreDataError))
            return
        }
        
        if coreDataService.checkToilets(context: managedObjectContext) > 0 {
            fetchDataFromCoreData(completion: completion)
        } else {
            fetchDataFromNetwork { [weak self] result in
                switch result {
                case .success(let toilets):
                    print("Sauvegarde des données (\(toilets.count) toilettes) avec Core Data.")
                    self?.saveData {
                        completion(.success(toilets))
                    }
                case .failure(let error):
                    print("ERREUR: " + error.rawValue)
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchDataFromNetwork(completion: @escaping (Result<[Toilet], APIError>) -> Void) {
        networkService.fetch { [weak self] (response: Result<DataOutput, APIError>) in
            switch response {
            case .success(let data):
                guard let toilets = data.records else {
                    print("ERREUR: Aucune donnée")
                    completion(.failure(.noData))
                    return
                }
                
                self?.toilets = toilets
                print("Toilettes récupérées du réseau: \(self?.toilets.count ?? 0)")
                completion(.success(toilets))
                
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
                completion(.failure(error))
            }
        }
    }
    
    private func fetchDataFromCoreData(completion: @escaping (Result<[Toilet], APIError>) -> Void) {
        guard let managedObjectContext else {
            completion(.failure(.coreDataError))
            return
        }
        
        let entities = coreDataService.fetchToilets(context: managedObjectContext)
        
        if entities.count > 0 {
            print("-> \(entities.count) toilettes disponibles.")
            
            for toilet in entities {
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
            completion(.success(toilets))
        } else {
            completion(.failure(.noData))
        }
    }
    
    private func saveData(completion: @escaping () -> Void) {
        coreDataService.saveData(with: self.toilets, completion: completion)
    }
    
    func getToilets() -> [Toilet] {
        return toilets
    }
    
    func getUserPosition() -> CLLocation? {
        return gpsService.getActualPosition()
    }
}
