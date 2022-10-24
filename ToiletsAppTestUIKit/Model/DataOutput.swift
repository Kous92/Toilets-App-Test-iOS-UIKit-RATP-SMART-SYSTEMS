//
//  DataOutput.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 16/10/2022.
//
import Foundation

// MARK: - Welcome
struct DataOutput: Codable {
    var parameters: Parameters
    var records: [Toilet]?
}

// MARK: - Parameters
struct Parameters: Codable {
    var dataset: String
    var rows: Int
}

// MARK: - Toilet
struct Toilet: Codable {
    var fields: Fields?
}

// MARK: - Fields
struct Fields: Codable {
    var horaire: String?
    var accesPmr: String?
    var arrondissement: Int?
    var geoPoint2D: [Double]?
    var adresse, type: String?
    var urlFicheEquipement: String?
    var gestionnaire: String?
    var source: String?
    var relaisBebe: String?
    var distance: Double?

    enum CodingKeys: String, CodingKey {
        case horaire, adresse, type, gestionnaire, source, arrondissement, distance
        case accesPmr = "acces_pmr"
        case geoPoint2D = "geo_point_2d"
        case urlFicheEquipement = "url_fiche_equipement"
        case relaisBebe = "relais_bebe"
    }
}
