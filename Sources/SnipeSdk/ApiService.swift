//
//  File.swift
//  
//
//  Created by Noman Khan on 12/08/23.
//

import Foundation

internal class ApiService {
//    private var baseUrl: String = "https://snipe-api-lfvnq7enja-el.a.run.app/api/"

    private var baseUrl: String = "https://d275-117-194-114-24.ngrok-free.app/api/"

    func get(endpoint: String, headers: [String: String]?=nil, callback: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: self.baseUrl + endpoint) else {
                callback(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
//            request.addValue("Bearer " + apiKey, forHTTPHeaderField: "Authorization")
            if let customHeaders = headers {
                      for (key, value) in customHeaders {
                          request.addValue(value, forHTTPHeaderField: key)
                      }
                  }
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    callback(nil)
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    callback(responseString)
                } else {
                    callback(nil)
                }
            }.resume()
        }
    }


    func post(endpoint: String, requestBody: [String: Any], headers: [String: String]? = nil, callback: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: self.baseUrl + endpoint) else {
                callback(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            if let customHeaders = headers {
                for (key, value) in customHeaders {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                request.httpBody = jsonData
                
                if let test = String(data: jsonData, encoding: .utf8) {
                             print("body \(test)")
                   
                         } else {
                             print("Failed to convert JSON data to string")
                         }
                
            } catch {
                print("JSON Serialization Error: \(error)")
                callback(nil)
                return
            }
            
            print("post api call: \(request)")
            print("api header : \(String(describing: request.allHTTPHeaderFields))")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    callback(nil)
                    return
                }
                
                guard let data = data else {
                    callback(nil)
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    callback(responseString)
                } else {
                    callback(nil)
                }
            }.resume()
        }
    }

}
