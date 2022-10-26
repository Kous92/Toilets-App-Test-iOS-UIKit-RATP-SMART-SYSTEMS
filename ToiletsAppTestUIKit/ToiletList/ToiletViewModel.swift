//
//  ToiletViewModel.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 16/10/2022.
//

import Foundation
import CoreLocation

final class ToiletViewModel {
    private let toilet: Toilet
    let address: String
    let opening: String
    let reducedMobility: String
    private(set) var distance: Double?
    private let userPosition: CLLocation?
    
    init(with toilet: Toilet, and userPosition: CLLocation?) {
        self.toilet = toilet
        self.address = toilet.fields?.adresse ?? "Adresse inconnue"
        self.opening = toilet.fields?.horaire ?? "Horaires indisponibles"
        self.reducedMobility = toilet.fields?.accesPmr ?? "Non"
        self.userPosition = userPosition
        
        self.setDistance()
    }
    
    private func setDistance() {
        print("-> Récupération de la distance")
        guard let userPosition, let coordinates = toilet.fields?.geoPoint2D else {
            return
        }
        
        let toiletPosition = CLLocation(latitude: coordinates[0], longitude: coordinates[1])
        self.distance = userPosition.distance(from: toiletPosition)
    }
    
    func getDistanceFormatted() -> String {
        guard let distance else {
            return ""
        }
        
        return distance < 1000 ? "\(Int(distance)) m" : "\(String(format:"%.02f", distance / 1000)) km"
    }
}
