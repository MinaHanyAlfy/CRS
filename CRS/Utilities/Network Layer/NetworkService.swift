//
//  NetworkServiceMock.swift
//  AssessmentApp
//
//  Created by Irfan Saeed on 19/01/2022.
//

import Foundation
import Alamofire
import Reachability

class NetworkService {
    let reach = try! Reachability() 
    static let shared = NetworkService()
    let reachability = try! Reachability()
    
   func getResultsStrings<M: Codable>(APICase: API,decodingModel: M.Type, completed: @escaping (Result<String,ErorrMessage> ) -> Void) {
//       if APICase.request.url?.absoluteString.contains("add_pm_visit") || APICase.request.url?.absoluteString.contains("add_am_visit") ||  APICase.request.url?.absoluteString.contains("report_pm_visiting_day") ||   APICase.request.url?.absoluteString.contains("report_am_visiting_day") {
//       
//   }
        var request : URLRequest = APICase.request
        request.httpMethod = APICase.method.rawValue
       reachability.whenUnreachable = { _ in
           print("Not reachable")
           switch APICase {
           case .addPMVisit,.addAMVisit:
               CoreDataManager.shared.saveReport(url: request.url?.absoluteString ?? "")
               completed((.failure(.InvalidRequest)))
           default:
               completed((.failure(.InvalidRequest)))
           }
       }

       do {
           try reachability.startNotifier()
       } catch {
           print("Unable to start notifier")
       }
//       UserDefaults.standard.set("add_am_visit", forKey: <#T##String#>)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error =  error {
                print("❌ Error: ",error)
                completed((.failure(.InvalidData)))
            }
            guard let data = data else {
                print("❌ Error in data: ",data)
                completed((.failure(.InvalidData)))
                return
            }
            
            guard let response =  response  as? HTTPURLResponse ,response.statusCode == 200 else {
                print("❌ Error in response: ",response)
                completed((.failure(.InvalidResponse)))
                return
            }
//            let decoder = JSONDecoder()
            do
            {
                
                guard let str = String(data: data, encoding: .utf8) else { return }
//                let results = try decoder.decode(M.self, from: data)
                print("✅ Results: ",str)
                
                completed((.success(str)))
                
            } catch {
                print(error)
                completed((.failure(.InvalidData)))
            }
            
        }
        task.resume()
    }
    func getResults<M: Codable>(APICase: API,decodingModel: M.Type, completed: @escaping (Result<M,ErorrMessage> ) -> Void) {
     
        let request : URLRequest = APICase.request
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error =  error {
                completed((.failure(.InvalidData)))
            }
            guard let data = data else {
                completed((.failure(.InvalidData)))
                return
            }
            guard let response =  response  as? HTTPURLResponse ,response.statusCode == 200 else{
                completed((.failure(.InvalidResponse)))
                return
            }
            let decoder = JSONDecoder()
            do
            {
               
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(M.self, from: data)
                print(results)
                completed((.success(results)))
                
            }catch {
                print(error)
                completed((.failure(.InvalidData)))
            }
            
        }
        task.resume()
    }
    
    
    //With String
    func getResultsStrings<M: Codable>(urlStr :String, decodingModel: M.Type, completed: @escaping (Result<String,ErorrMessage> ) -> Void) {

        guard let url = URL(string: urlStr) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
             if let error =  error {
                 print("❌ Error: ",error)
                 completed((.failure(.InvalidData)))
             }
             guard let data = data else {
                 print("❌ Error in data: ")
                 completed((.failure(.InvalidData)))
                 return
             }
             
             guard let response =  response  as? HTTPURLResponse ,response.statusCode == 200 else {
                 print("❌ Error in response: ")
                 completed((.failure(.InvalidResponse)))
                 return
             }
             do
             {
                 guard let str = String(data: data, encoding: .utf8) else { return }
                 print("✅ Results: ",str)
                 
                 completed((.success(str)))
                 
             } catch {
                 print(error)
                 completed((.failure(.InvalidData)))
             }
             
         }
         task.resume()
     }
}
