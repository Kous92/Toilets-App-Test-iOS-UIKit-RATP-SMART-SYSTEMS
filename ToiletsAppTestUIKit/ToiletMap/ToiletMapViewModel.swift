//
//  ToiletMapViewModel.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 26/10/2022.
//

import Foundation
import Combine

final class ToiletMapViewModel {
    private var toilets = [Toilet]()
    var toiletViewModels = [ToiletViewModel]()
    
    private var updateResult = PassthroughSubject<Bool, APIError>()
    private var isLoading = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, APIError> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
    
    private let service: APIService
    
    init(service: APIService) {
        self.service = service
    }
    
    func getData() {
        isLoading.send(true)
        service.fetch { [weak self] result in
            switch result {
            case .success(let toilets):
                print("[ToiletMapViewModel] Données récupérées: \(toilets.count) toilettes")
                self?.toilets = toilets
                self?.parseData()
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
                self?.updateResult.send(completion: .failure(error))
            }
        }
    }
}


extension ToiletMapViewModel {
    private func parseData() {
        guard toilets.count > 0 else {
            updateResult.send(false)
            return
        }
        
        toiletViewModels.removeAll()
        toilets.forEach { toiletViewModels.append(getToiletViewModel(with: $0)) }
        updateResult.send(true)
    }
    
    private func getToiletViewModel(with toilet: Toilet) -> ToiletViewModel {
        return ToiletViewModel(with: toilet, and: service.getUserPosition())
    }
}
