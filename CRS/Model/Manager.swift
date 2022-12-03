//
//  Manager.swift
//  CRS
//
//  Created by John Doe on 2022-12-02.
//

import Foundation

// MARK: - Manager
struct Manager: Codable {
    var the0, the1, the2, level: String?
    var id, name: String?

    enum CodingKeys: String, CodingKey {
        case the0 = "0"
        case the1 = "1"
        case the2 = "2"
        case level, id, name
    }
}

typealias Managers = [Manager]
