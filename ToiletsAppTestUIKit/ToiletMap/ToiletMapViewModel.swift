//
//  ToiletMapViewModel.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 26/10/2022.
//

import Foundation
import Combine

final class ToiletMapViewModel {
    private let service: APIService
    
    init(service: APIService) {
        self.service = service
    }
}
