//
//  PreviousLogin.swift
//  CRS
//
//  Created by John Doe on 2023-03-24.
//

import Foundation

// MARK: - PreviousLoginElement
struct PreviousLoginElement: Codable {
    let latitude, longitude, dateTime, amOrPm: String?

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case dateTime = "date_time"
        case amOrPm = "am_or_pm"
    }
}

typealias PreviousLogin = [PreviousLoginElement]
