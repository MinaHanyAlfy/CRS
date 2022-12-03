//
//  Key.swift
//  CRS
//
//  Created by John Doe on 2022-12-02.
//

import Foundation

// MARK: - Key
struct Key: Codable {
    var keyPersonID, keyPersonName, specialityName, mobile: String?
    var accountID: String?

    enum CodingKeys: String, CodingKey {
        case keyPersonID = "key_person_id"
        case keyPersonName = "key_person_name"
        case specialityName = "speciality_name"
        case mobile
        case accountID = "account_id"
    }
}

typealias Keys = [Key]
