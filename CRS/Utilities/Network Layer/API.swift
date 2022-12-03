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
    case companyAuth(company: String, password: String, level: String)
    case userLoginID(name: String, password: String, level: String)
    case getProducts(level: String,userId: String)
    case getManagers(level: String,userId: String)
    case getCustomers(level: String, userId: String)
    case getAccounts(level: String, userId: String)
    case getKeys(level: String, userId: String)
    case getPharmacies(level: String, userId: String)
    case readPMVisits
    case readPMVisitingDay
    case reportPMVisitingDay
    case updatePMVisitingDayComment
    case addPMVisit
    case storeCustomerLocation
    case updatePMVisit
    case deletePMVisit
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
    case mockLocationAllowedApps
    
    
    
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
        case .companyAuth(let company, let password, let level):
            return [URLQueryItem(name: "company", value: company), URLQueryItem(name: "password", value: password), URLQueryItem(name: "level", value: level)]
        case .userLoginID(let name,let password,let level):
            return [URLQueryItem(name: "user_name", value: name), URLQueryItem(name: "user_pass", value: password), URLQueryItem(name: "level", value: level), URLQueryItem(name: "user_log_in", value: "x")]
        case .getProducts(let level, let userId):
            return [URLQueryItem(name: "products", value: "x"),URLQueryItem(name: "level",value: level),URLQueryItem(name: "user_id", value: userId)]
        case .getManagers(let level, let userId):
            return [URLQueryItem(name: "managers", value: "x"),URLQueryItem(name: "level",value: level),URLQueryItem(name: "user_id", value: userId)]
        case .getCustomers(let level, let userId):
            return [URLQueryItem(name: "customers", value: "x"),URLQueryItem(name: "level",value: level),URLQueryItem(name: "user_id", value: userId)]
        case .getAccounts(let level, let userId):
            return [URLQueryItem(name: "accounts", value: "x"),URLQueryItem(name: "level",value: level),URLQueryItem(name: "user_id", value: userId)]
        case .getKeys(let level, let userId):
            return [URLQueryItem(name: "keys", value: "x"),URLQueryItem(name: "level",value: level),URLQueryItem(name: "user_id", value: userId)]
        case .getPharmacies(let level, let userId):
                return [URLQueryItem(name: "pharmacies", value: "x"),URLQueryItem(name: "level",value: level),URLQueryItem(name: "user_id", value: userId)]
            

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


