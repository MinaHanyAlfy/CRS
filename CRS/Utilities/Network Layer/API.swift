//
//  API.swift
//  AssessmentApp
//
//  Created by John Doe on 2022-06-15.
//

import Foundation
enum API{
    case getDefault
    case login
    case companyLogin(company_log_in: String,password: String)
    case companyAuth
    case userLogin
    case getProducts
    case getManagers
    case getCustomers
    case readPMVisits
    case readPMVisitingDay
    case reportPMVisitingDay
    case updatePMVisitingDayComment
    case addPMVisit
    case storeCustomerLocation
    case updatePMVisit
    case deletePMVisit
    case getAccounts
    case readAMVisits
    case readAMVisitingDay
    case reportAMVisitingDay
    case updateAMVisitingDayComment
    case addAMVisit
    case storeAccountLocation
    case updateAMVisit
    case deleteAMVisit
    case mockLocation
    case logging
    case addLogIn
    case getKeys
    case getPharmacies
    case mockLocationAllowedApps
//    case
    
    
    
}


extension API: EndPoint{
    var baseURL: String {
        return "https://ark-crs.com"
    }
    var urlSubFolder: String {
        return "/demo"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .companyLogin(let company, let password):
            return [URLQueryItem(name: "company_log_in", value: company),URLQueryItem(name: "password", value: password)]
        default:
            return [URLQueryItem(name: "", value: nil)]
        }
    }
    
    
    
    
    var method: HTTPMethod {
        switch self {
        default :
            return  .get
        }
    }
    
    
    var path: String {
        return "android.php"
    }
    
    var body: [String: Any]? {
        switch self{
        default:
            return nil
        }
    }
    
    
    

}


