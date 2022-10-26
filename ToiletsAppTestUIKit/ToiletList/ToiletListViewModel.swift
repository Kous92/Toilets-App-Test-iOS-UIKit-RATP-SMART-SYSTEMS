//
//  ToiletListViewModel.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 26/10/2022.
//

import Foundation
import Combine

final class ToiletListViewModel {
    private var toilets = [Toilet]()
    private var toiletViewModels = [ToiletViewModel]()
    var filteredToiletViewModels = [ToiletViewModel]()
    
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
                print("[ToiletListViewModel] Données récupérées: \(toilets.count) toilettes")
                self?.toilets = toilets
                self?.parseData()
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
                self?.updateResult.send(completion: .failure(error))
            }
        }
    }
    
    func filterPmrData(isEnabled: Bool) {
        guard toilets.count > 0 else {
            updateResult.send(false)
            return
        }
        
        isLoading.send(true)
        filteredToiletViewModels = isEnabled ? toiletViewModels.filter { $0.reducedMobility == "Oui" } : toiletViewModels
        updateResult.send(true)
    }
    
    // Du plus proche au moins proche
    func sortByDistance(isEnabled: Bool) {
        guard toilets.count > 0 else {
            updateResult.send(false)
            return
        }
        
        isLoading.send(true)
        
        if isEnabled {
            filteredToiletViewModels = toiletViewModels.sorted(by: { toilet1, toilet2 in
                return toilet1.distance ?? Double.infinity < toilet2.distance ?? Double.infinity
            })
        } else {
            filteredToiletViewModels = toiletViewModels
        }
        
        updateResult.send(true)
    }
}

extension ToiletListViewModel {
    private func parseData() {
        guard toilets.count > 0 else {
            updateResult.send(false)
            return
        }
        
        toiletViewModels.removeAll()
        toilets.forEach { toiletViewModels.append(getToiletViewModel(with: $0)) }
        filteredToiletViewModels = toiletViewModels
        updateResult.send(true)
    }
    
    private func getToiletViewModel(with toilet: Toilet) -> ToiletViewModel {
        return ToiletViewModel(with: toilet, and: service.getUserPosition())
    }
}
