//
//  APIService.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 16/10/2022.
//

import Foundation
import CoreLocation

protocol APIService {
    func fetch(completion: @escaping (Result<[Toilet], APIError>) -> ())
    func getUserPosition() -> CLLocation?
}

extension APIService {
    func getUserPosition() -> CLLocation? {
        return nil
    }
}
