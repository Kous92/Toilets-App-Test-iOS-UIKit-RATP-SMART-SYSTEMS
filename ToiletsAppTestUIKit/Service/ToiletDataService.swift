//
//  ToiletDataService.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 17/10/2022.
//

import Foundation

final class ToiletDataService {
    private var toilets = [Toilet]()
    static let shared = ToiletDataService()
    
    private init() {
        
    }
    
    func fetchDataFromNetwork(completion: @escaping (Result<DataOutput, APIError>) -> Void) {
        let service = NetworkService()
        service.fetch { [weak self] (response: Result<DataOutput, APIError>) in
            switch response {
            case .success(let data):
                guard let toilets = data.records else {
                    print("ERREUR: Aucune donnée")
                    return
                }
                
                self?.toilets = toilets
                print("Toilettes récupérées: \(toilets.count)")
                
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
            }
        }
    }
    
    func getToilets() -> [Toilet] {
        return toilets
    }
}
