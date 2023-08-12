//
//  File.swift
//  
//
//  Created by Noman Khan on 12/08/23.
//

import Foundation

internal class ApiService {
    private var baseUrl: String = "https://jsonplaceholder.typicode.com/todos/1"

    func get(endpoint: String, apiKey: String, callback: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: self.baseUrl + endpoint) else {
                callback(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
//            request.addValue("Bearer " + apiKey, forHTTPHeaderField: "Authorization")
            
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

    func post(endpoint: String, apiKey: String, requestBody: String, callback: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: self.baseUrl + endpoint) else {
                callback(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer " + apiKey, forHTTPHeaderField: "Authorization")
            request.httpBody = requestBody.data(using: .utf8)
            
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
}
