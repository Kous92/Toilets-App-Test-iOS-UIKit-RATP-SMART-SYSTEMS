//
//  ToiletViewModel.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 16/10/2022.
//

import Foundation

final class ToiletViewModel {
    let address: String
    let opening: String
    let reducedMobility: String
    private(set) var distance: String
    
    init(address: String, opening: String, reducedMobility: String, distance: String) {
        self.address = address
        self.opening = opening
        self.reducedMobility = reducedMobility
        self.distance = distance
    }
}
