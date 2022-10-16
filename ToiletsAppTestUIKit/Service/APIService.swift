//
//  APIService.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 16/10/2022.
//

import Foundation

protocol APIService {
    func fetch<T: Codable>(completion: @escaping (Result<T, APIError>) -> ())
}
