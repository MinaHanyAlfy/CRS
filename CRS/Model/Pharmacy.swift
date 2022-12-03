//
//  Pharmacy.swift
//  CRS
//
//  Created by John Doe on 2022-12-02.
//

import Foundation

// MARK: - Pharmacy
struct Pharmacy: Codable {
    var pharmacyID, pharmacyName, address, phone: String?
    var customerID: String?

    enum CodingKeys: String, CodingKey {
        case pharmacyID = "pharmacy_id"
        case pharmacyName = "pharmacy_name"
        case address, phone
        case customerID = "customer_id"
    }
}

typealias Pharmacies = [Pharmacy]
