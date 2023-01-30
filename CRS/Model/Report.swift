//
//  Report.swift
//  CRS
//
//  Created by John Doe on 2023-01-29.
//

import Foundation
    
// MARK: - Report
struct Report: Codable {
    let accountID, accountName, accountPotential, accountPrescription: String
    let specialityName, serial, product1_ID, product2_ID: String
    let product3_ID, product4_ID, fManagerDv, mManagerDv: String
    let hManagerDv, visitComment, visitingDayDate, kIDS: String
    let kNames, kSpecialities, kMobiles, kComments: String
    let dvReport: String

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case accountName = "account_name"
        case accountPotential = "account_potential"
        case accountPrescription = "account_prescription"
        case specialityName = "speciality_name"
        case serial
        case product1_ID = "product_1_id"
        case product2_ID = "product_2_id"
        case product3_ID = "product_3_id"
        case product4_ID = "product_4_id"
        case fManagerDv = "f_manager_dv"
        case mManagerDv = "m_manager_dv"
        case hManagerDv = "h_manager_dv"
        case visitComment = "visit_comment"
        case visitingDayDate = "visiting_day_date"
        case kIDS = "k_ids"
        case kNames = "k_names"
        case kSpecialities = "k_specialities"
        case kMobiles = "k_mobiles"
        case kComments = "k_comments"
        case dvReport = "dv_report"
    }
}

typealias Reports = [Report]
