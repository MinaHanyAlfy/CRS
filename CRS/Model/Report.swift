//
//  Report.swift
//  CRS
//
//  Created by John Doe on 2023-01-29.
//

import Foundation
    
// MARK: - Report
struct ReportAM: Codable {
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountID = try values.decodeIfPresent(String.self, forKey: .accountID) ?? "0"
        accountName = try values.decodeIfPresent(String.self, forKey: .accountName) ?? ""
        accountPotential = try values.decodeIfPresent(String.self, forKey: .accountPotential) ?? "0"
        accountPrescription = try values.decodeIfPresent(String.self, forKey: .accountPrescription) ?? "0"
        specialityName = try values.decodeIfPresent(String.self, forKey: .specialityName) ?? ""
        serial = try values.decodeIfPresent(String.self, forKey: .serial) ?? "0"
        product1_ID = try values.decodeIfPresent(String.self, forKey: .product1_ID) ?? "0"
        product2_ID = try values.decodeIfPresent(String.self, forKey: .product2_ID) ?? "0"
        product3_ID = try values.decodeIfPresent(String.self, forKey: .product3_ID) ?? "0"
        product4_ID = try values.decodeIfPresent(String.self, forKey: .product4_ID) ?? "0"
        fManagerDv = try values.decodeIfPresent(String.self, forKey: .fManagerDv) ?? "0"
        mManagerDv = try values.decodeIfPresent(String.self, forKey: .mManagerDv) ?? "0"
        hManagerDv = try values.decodeIfPresent(String.self, forKey: .hManagerDv) ?? "0"
        visitComment = try values.decodeIfPresent(String.self, forKey: .visitComment) ?? ""
        visitingDayDate = try values.decodeIfPresent(String.self, forKey: .visitingDayDate) ?? ""
        kIDS = try values.decodeIfPresent(String.self, forKey: .kIDS) ?? "0"
        kNames = try values.decodeIfPresent(String.self, forKey: .kNames) ?? ""
        kMobiles = try values.decodeIfPresent(String.self, forKey: .kMobiles) ?? ""
        kSpecialities = try values.decodeIfPresent(String.self, forKey: .kSpecialities) ?? ""
        kComments = try values.decodeIfPresent(String.self, forKey: .kComments) ?? ""
        dvReport = try values.decodeIfPresent(String.self, forKey: .dvReport) ?? "0"
        }
}

typealias ReportsAM = [ReportAM]

// MARK: - ReportPMElement
struct ReportPM: Codable {
    let customerID, customerName, customerPotential: String?
       let customerPrescription: String?
       let specialityName, serial, product1_ID, product2_ID: String?
       let product3_ID, product4_ID, fManagerDv, mManagerDv: String?
       let hManagerDv, visitComment, visitingDayDate, pIDS: String?
       let pNames, pAddresses, pPhones, pComments: String?
       let dvReport: String?

    enum CodingKeys: String, CodingKey {
          case customerID = "customer_id"
          case customerName = "customer_name"
          case customerPotential = "customer_potential"
          case customerPrescription = "customer_prescription"
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
          case pIDS = "p_ids"
          case pNames = "p_names"
          case pAddresses = "p_addresses"
          case pPhones = "p_phones"
          case pComments = "p_comments"
          case dvReport = "dv_report"
      }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customerID = try values.decodeIfPresent(String.self, forKey: .customerID) ?? "0"
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName) ?? ""
        customerPotential = try values.decodeIfPresent(String.self, forKey: .customerPotential) ?? "0"
        customerPrescription = try values.decodeIfPresent(String.self, forKey: .customerPrescription) ?? "0"
        specialityName = try values.decodeIfPresent(String.self, forKey: .specialityName) ?? ""
        serial = try values.decodeIfPresent(String.self, forKey: .serial) ?? "0"
        product1_ID = try values.decodeIfPresent(String.self, forKey: .product1_ID) ?? "0"
        product2_ID = try values.decodeIfPresent(String.self, forKey: .product2_ID) ?? "0"
        product3_ID = try values.decodeIfPresent(String.self, forKey: .product3_ID) ?? "0"
        product4_ID = try values.decodeIfPresent(String.self, forKey: .product4_ID) ?? "0"
        fManagerDv = try values.decodeIfPresent(String.self, forKey: .fManagerDv) ?? "0"
        mManagerDv = try values.decodeIfPresent(String.self, forKey: .mManagerDv) ?? "0"
        hManagerDv = try values.decodeIfPresent(String.self, forKey: .hManagerDv) ?? "0"
        visitComment = try values.decodeIfPresent(String.self, forKey: .visitComment) ?? ""
        visitingDayDate = try values.decodeIfPresent(String.self, forKey: .visitingDayDate) ?? ""
        pIDS = try values.decodeIfPresent(String.self, forKey: .pIDS) ?? "0"
        pNames = try values.decodeIfPresent(String.self, forKey: .pNames) ?? ""
        pPhones = try values.decodeIfPresent(String.self, forKey: .pPhones) ?? ""
        pAddresses = try values.decodeIfPresent(String.self, forKey: .pAddresses) ?? ""
        pComments = try values.decodeIfPresent(String.self, forKey: .pComments) ?? ""
        dvReport = try values.decodeIfPresent(String.self, forKey: .dvReport) ?? "0"
        }
}

typealias ReportsPM = [ReportPM]
