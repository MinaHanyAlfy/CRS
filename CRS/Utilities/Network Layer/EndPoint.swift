//
//  EndPoint.swift
//  AssessmentApp
//
//  Created by John Doe on 2022-06-15.
//

import Foundation

fileprivate let requestTimeOut: Double = 60
enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

protocol EndPoint{
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var urlSubFolder: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}
extension EndPoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: baseURL)!
        components.path = urlSubFolder + "/" + path
        components.queryItems = queryItems
        print("Url", components.url)
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var request =  URLRequest(url: url,timeoutInterval: requestTimeOut)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
    
}

