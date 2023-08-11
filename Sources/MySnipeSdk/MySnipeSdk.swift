import Foundation

public struct MySnipeSdk {
    private var _apiKey: String?
    public init(apiKey:String) {
        _apiKey=apiKey
        
    }
    
    public func trackEvent(eventId: String, transactionAmount: Int? = nil, partialPercentage: Int? = nil)  {
        guard let apiKey = _apiKey else {
            print("API Key not initialized. Call init() first.")
            return
        }

       let requestBody = buildRequestBody(eventId: eventId, transactionAmount: transactionAmount, partialPercentage: partialPercentage)

        let apiService = ApiService()
        apiService.post(endpoint: "trigger-event", apiKey: apiKey, requestBody: requestBody) { response in
            if let response = response {
                print("POST Response: \(response)")
                
            } else {
                print("POST Request failed")
            }
        }
    }
    
    private struct Tokens {
        let value: NSNumber
        let tokenId: String
    }

    private func parseTokenResponse(json: String) -> [Tokens] {
        guard let data = json.data(using: .utf8) else {
            return []
        }
        
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
            
            var resultList: [Tokens] = []
            
            for tokenObj in jsonArray {
                if let value = tokenObj["value"] as? Int, let tokenId = tokenObj["token_id"] as? String {
                    resultList.append(Tokens(value: NSNumber(value: value), tokenId: tokenId))
                }
            }
            
            return resultList
        } catch {
            print("Error parsing JSON: \(error)")
            return []
        }
    }

    private func convertTokensListToMapList(tokensList: [Tokens]) -> [[String: Any]] {
        return tokensList.map { token in
            return [
                "value": token.value,
                "token_id": token.tokenId
            ]
        }
    }


  public  func getCoinData(snipeId: String) -> [[String: Any]] {
        var tempData: [Tokens] = []
        
        guard let apiKey = _apiKey else {
            print("API Key not initialized. Call init() first.")
            return []
        }

        let apiService = ApiService()
        apiService.get(endpoint: "get-user-token/\(snipeId)", apiKey: apiKey) { response in
            if let response = response {
                print("GET Response: \(response)")
                tempData = self.parseTokenResponse(json: response)
            } else {
                print("GET Request failed")
            }
        }
        
        return convertTokensListToMapList(tokensList: tempData)
    }

    
}


private func buildRequestBody(eventId: String, transactionAmount: Int?, partialPercentage: Int?) -> String {
    var parts: [String] = []

    parts.append("eventId=\(eventId)")

    if let transactionAmount = transactionAmount {
        parts.append("transactionAmount=\(transactionAmount)")
    }

    if let partialPercentage = partialPercentage {
        parts.append("partialPercentage=\(partialPercentage)")
    }

    return parts.joined(separator: "&")
}



private class ApiService {
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
