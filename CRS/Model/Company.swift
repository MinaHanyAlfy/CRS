//
//  Company.swift
//  CRS
//
//  Created by John Doe on 2022-12-01.
//

import Foundation


// MARK: - CompanyElement
struct CompanyElement: Codable {
    var serial, name, pass, title: String?
    var address, latitude, longitude, tel: String?
    var retrospectiveReport: String?

    enum CodingKeys: String, CodingKey {
        case serial, name, pass, title, address, latitude, longitude, tel
        case retrospectiveReport = "retrospective_report"
    }
}

typealias Company = [CompanyElement]
