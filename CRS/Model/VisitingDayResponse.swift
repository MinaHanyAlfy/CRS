//
//  VisitingDayResponse.swift
//  CRS
//
//  Created by John Doe on 2023-03-26.
//  Copyright © 2023 ARK. All rights reserved.
//

import Foundation
// MARK: - VisitingDayResponseElement
struct VisitingDayResponseElement: Codable {
    let visitingDayComment: String? = ""
    let visitingDayStatus: String?

    enum CodingKeys: String, CodingKey {
        case visitingDayComment = "visiting_day_comment"
        case visitingDayStatus = "visiting_day_status"
    }
    
}

typealias VisitingDayResponse = [VisitingDayResponseElement]
