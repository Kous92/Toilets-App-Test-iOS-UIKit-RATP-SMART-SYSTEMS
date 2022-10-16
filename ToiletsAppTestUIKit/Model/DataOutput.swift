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
    var records: [Record]?
}

// MARK: - Parameters
struct Parameters: Codable {
    var dataset: String
    var rows: Int
}

// MARK: - Record
struct Record: Codable {
    var fields: Fields?
}

// MARK: - Fields
struct Fields: Codable {
    var horaire: String?
    var accesPmr: String?
    var arrondissement: Int?
    var geoPoint2D: [Double]?
    var adresse, type: String?

    enum CodingKeys: String, CodingKey {
        case horaire
        case accesPmr = "acces_pmr"
        case arrondissement
        case geoPoint2D = "geo_point_2d"
        case adresse, type
    }
}
