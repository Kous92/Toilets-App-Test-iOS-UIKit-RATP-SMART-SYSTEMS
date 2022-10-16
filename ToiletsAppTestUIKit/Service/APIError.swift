//
//  APIError.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 16/10/2022.
//

import Foundation

enum APIError: String, Error {
    case notFound = "Erreur 404: Ressource non trouvée."
    case invalidURL = "Erreur: URL invalide."
    case decodeError = "Erreur au décodage des données."
    case networkError = "Erreur réseau."
    case unknownError = "Une erreur est survenue."
}
