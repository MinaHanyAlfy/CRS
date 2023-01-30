//
//  API.swift
//  AssessmentApp
//
//  Created by John Doe on 2022-06-15.
//

import Foundation

enum API {
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
    case addPMVisit(level: String, userId:String, manager_level:String? = "", manager_id: String? = "0" , product_1: String, product_2: String? = "0", product_3: String? = "0", product_4: String? = "0",customer_id: String, lat: String? = "0.0", long: String? = "0.0", comment: String? = "", plan_date: String? = "", recipient_level: String? = "", recipient_id: String? = "", message: String? = "", visiting_day_date: String? = "", p_ids: String? = "", p_names: String? = "", p_addresses: String? = "", p_phones: String? = "", p_comments: String? = "")
    case addAMVisit(level: String, userId:String, manager_level:String? = "", manager_id: String? = "", product_1: String, product_2: String? = "", product_3: String? = "", product_4: String? = "",account_id: String? = "", lat: String? = "0.0", long: String? = "0.0", comment: String? = "", plan_date: String? = "", recipient_level: String? = "", recipient_id: String? = "", message: String? = "", visiting_day_date: String? = "", k_ids: String? = "", k_names: String? = "", k_specialities: String? = "", k_mobiles: String? = "", k_comments: String? = "")
    case readPMVisits(level: String, userId:String, reportDate: String)
    case readPMVisitingDay(level: String, userId:String, reportDate: String)
    case readAMVisits(level: String, userId:String, reportDate: String)
    case readAMVisitingDay(level: String, userId:String, reportDate: String)
    case updatePMVisitingDayComment(level: String, userId: String, reportDate: String, comment: String)
    case updateAMVisitingDayComment(level: String, userId: String, reportDate: String, comment: String)
    case reportPMVisitingDay(level: String, userId:String, reportDate: String)
    case reportAMVisitingDay(level: String, userId:String, reportDate: String)
    case storeCustomerLocation(customerId: String, lat: String, long: String)
    case storeAccountLocation(accountId: String,lat: String,long: String)

    case updatePMVisit
    case deletePMVisit
    case updateAMVisit
    case deleteAMVisit
    
    /////// ///// /////
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
        case .addPMVisit(let level, let userId, let manager_level, let manager_id, let product_1, let product_2, let product_3, let product_4, let customer_id, let lat, let long, let comment, let plan_date, let recipient_level, let recipient_id, let message ,let visiting_day_date, let p_ids, let p_names, let p_addresses, let p_phones, let p_comments):
            return [URLQueryItem(name: "add_pm_visit", value: "x"),
                    URLQueryItem(name: "level",value: level),
                    URLQueryItem(name: "user_id", value: userId),
                    URLQueryItem(name: "manager_level", value: manager_level),
                    URLQueryItem(name: "manager_id",value: manager_id),
                    URLQueryItem(name: "product_1", value: product_1),
                    URLQueryItem(name: "product_2", value: product_2),
                    URLQueryItem(name: "product_3",value: product_3),
                    URLQueryItem(name: "product_4", value: product_4),
                    URLQueryItem(name: "customer_id", value: customer_id),
                    URLQueryItem(name: "lat", value: lat),
                    URLQueryItem(name: "long",value: long),
                    URLQueryItem(name: "comment", value: comment),
                    URLQueryItem(name: "plan_date", value: plan_date),
                    URLQueryItem(name: "recipient_level", value: recipient_level),
                    URLQueryItem(name: "recipient_id",value: recipient_id),
                    URLQueryItem(name: "message", value: message),
                    URLQueryItem(name: "visiting_day_date", value: visiting_day_date),
                    URLQueryItem(name: "p_ids",value: p_ids),
                    URLQueryItem(name: "p_names", value: p_names),
                    URLQueryItem(name: "p_addresses", value: p_addresses),
                    URLQueryItem(name: "p_phones",value: p_phones),
                    URLQueryItem(name: "p_comments", value: p_comments)
            ]
        case .addAMVisit(let level, let userId, let manager_level, let manager_id, let product_1, let product_2, let product_3, let product_4, let account_id, let lat, let long, let comment, let plan_date, let recipient_level, let recipient_id, let message ,let visiting_day_date, let k_ids, let k_names, let k_specialities, let k_mobiles, let k_comments):
            return [URLQueryItem(name: "add_am_visit", value: "x"),
                    URLQueryItem(name: "level",value: level),
                    URLQueryItem(name: "user_id", value: userId),
                    URLQueryItem(name: "manager_level", value: manager_level),
                    URLQueryItem(name: "manager_id",value: manager_id),
                    URLQueryItem(name: "product_1", value: product_1),
                    URLQueryItem(name: "product_2", value: product_2),
                    URLQueryItem(name: "product_3",value: product_3),
                    URLQueryItem(name: "product_4", value: product_4),
                    URLQueryItem(name: "account_id", value: account_id),
                    URLQueryItem(name: "lat", value: lat),
                    URLQueryItem(name: "long",value: long),
                    URLQueryItem(name: "comment", value: comment),
                    URLQueryItem(name: "plan_date", value: plan_date),
                    URLQueryItem(name: "recipient_level", value: recipient_level),
                    URLQueryItem(name: "recipient_id",value: recipient_id),
                    URLQueryItem(name: "message", value: message),
                    URLQueryItem(name: "visiting_day_date", value: visiting_day_date),
                    URLQueryItem(name: "k_ids",value: k_ids),
                    URLQueryItem(name: "k_names", value: k_names),
                    URLQueryItem(name: "k_specialities", value: k_specialities),
                    URLQueryItem(name: "k_mobiles",value: k_mobiles),
                    URLQueryItem(name: "k_comments", value: k_comments)
            ]
        case .updatePMVisitingDayComment(let level, let userId, let reportDate, let comment):
            return [URLQueryItem(name: "level",value: level),
                    URLQueryItem(name: "user_id", value: userId),
                    URLQueryItem(name: "report_date", value: reportDate),
                    URLQueryItem(name: "comment", value: comment),
                    URLQueryItem(name: "update_am_visiting_day_comment", value: "x")
                ]
        case .updateAMVisitingDayComment(let level, let userId, let reportDate, let comment):
            return [URLQueryItem(name: "level",value: level),
                    URLQueryItem(name: "user_id", value: userId),
                    URLQueryItem(name: "report_date", value: reportDate),
                    URLQueryItem(name: "comment", value: comment),
                    URLQueryItem(name: "update_pm_visiting_day_comment", value: "x")
                ]
        case .readAMVisits(let level, let userId, let reportDate):
            return [URLQueryItem(name: "level",value: level),
                    URLQueryItem(name: "user_id", value: userId),
                    URLQueryItem(name: "report_date", value: reportDate),
                    URLQueryItem(name: "read_am_visits", value: "x")
                ]
        case .readPMVisits(let level, let userId, let reportDate):
            return [URLQueryItem(name: "level",value: level),
                    URLQueryItem(name: "user_id", value: userId),
                    URLQueryItem(name: "report_date", value: reportDate),
                    URLQueryItem(name: "read_pm_visits", value: "x")
                ]
        case .readAMVisitingDay(let level, let userId, let reportDate):
            return [URLQueryItem(name: "level",value: level),
                    URLQueryItem(name: "user_id", value: userId),
                    URLQueryItem(name: "report_date", value: reportDate),
                    URLQueryItem(name: "read_am_visiting_day", value: "x")
                ]
        case .readPMVisitingDay(let level, let userId, let reportDate):
            return [URLQueryItem(name: "level",value: level),
                    URLQueryItem(name: "user_id", value: userId),
                    URLQueryItem(name: "report_date", value: reportDate),
                    URLQueryItem(name: "read_pm_visiting_day", value: "x")
                ]
        case .reportAMVisitingDay(let level, let userId, let reportDate):
            return [URLQueryItem(name: "level",value: level),
                    URLQueryItem(name: "user_id", value: userId),
                    URLQueryItem(name: "report_date", value: reportDate),
                    URLQueryItem(name: "report_am_visiting_day", value: "x")
                ]
        case .reportPMVisitingDay(let level, let userId, let reportDate):
            return [URLQueryItem(name: "level",value: level),
                    URLQueryItem(name: "user_id", value: userId),
                    URLQueryItem(name: "report_date", value: reportDate),
                    URLQueryItem(name: "report_pm_visiting_day", value: "x")
                ]
        case .storeCustomerLocation(let customerId,let lat,let long):
            return [URLQueryItem(name: "customer_id",value: customerId),
                    URLQueryItem(name: "lat", value: lat),
                    URLQueryItem(name: "long", value: long),
                    URLQueryItem(name: "store_customer_location", value: "x")
                ]
        case .storeAccountLocation(let accountId,let lat,let long):
            return [URLQueryItem(name: "account_id",value: accountId),
                    URLQueryItem(name: "lat", value: lat),
                    URLQueryItem(name: "long", value: long),
                    URLQueryItem(name: "store_account_location", value: "x")
                ]

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


