//
//  NetworkServiceMock.swift
//  AssessmentApp
//
//  Created by Irfan Saeed on 19/01/2022.
//

import Foundation
import Alamofire


class NetworkServiceMock {
    
    static let shared = NetworkServiceMock()
    
   func getResultsStrings<M: Codable>(APICase: API,decodingModel: M.Type, completed: @escaping (Result<String,ErorrMessage> ) -> Void) {
        var request : URLRequest = APICase.request

        request.httpMethod = APICase.method.rawValue
       
        
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
            let decoder = JSONDecoder()
            do
            {
                
                guard let str = String(data: data, encoding: .utf8) else { return }
//                let results = try decoder.decode(M.self, from: data)
                print("✅ Results: ",str)
                
                completed((.success(str)))
                
            }catch {
                print(error)
                completed((.failure(.InvalidData)))
            }
            
        }
        task.resume()
    }
    func getResults<M: Codable>(APICase: API,decodingModel: M.Type, completed: @escaping (Result<M,ErorrMessage> ) -> Void) {
     
        var request : URLRequest = APICase.request
        
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
    
}
