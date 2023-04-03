//
//  Account.swift
//  CRS
//
//  Created by John Doe on 2022-12-02.
//

import Foundation

// MARK: - Account
struct Account: Codable {
    var accountID, accountName, accountPotential, accountPrescription: String?
    var keyPerson, accountLatitude, accountLongitude, specialityName: String?
    var zoneName: String? = "No Zone"

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case accountName = "account_name"
        case accountPotential = "account_potential"
        case accountPrescription = "account_prescription"
        case keyPerson = "key_person"
        case accountLatitude = "account_latitude"
        case accountLongitude = "account_longitude"
        case specialityName = "speciality_name"
        case zoneName = "zone_name"
    }
}

typealias Accounts = [Account]

