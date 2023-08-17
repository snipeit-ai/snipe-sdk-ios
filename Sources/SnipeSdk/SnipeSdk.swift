import Foundation

@available(iOS 15.0, *)
public struct SnipeSdk {
    private var _apiKey: String?
    public init(apiKey:String) {
        _apiKey=apiKey
        
    }
    
    public  func signUp(hash: String) async -> Any {
        guard let apiKey = _apiKey else {
            print("API Key not initialized.")
            return ""
        }
        
        var output: String = ""
        
        let apiService = ApiService()
        
        do {
            let response = try await apiService.post(endpoint: "users", requestBody: ["hash": hash], headers: ["x-api-key": apiKey])
            
            print("POST Response: \(response)")
//            output = parseSnipeId(jsonResponse: response) ?? ""
            output = response
            return output
        } catch {
            print("POST Request failed: \(error)")
            return ""
        }
        
       
    }

    
//   private func parseSnipeId(jsonResponse: String) -> String? {
//        if let data = jsonResponse.data(using: .utf8) {
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let dataObject = json["data"] as? [String: Any],
//                   let valueObject = dataObject["value"] as? [String: Any],
//                   let snipeId = valueObject["snipe_id"] as? String {
//                    return snipeId
//                }
//            } catch {
//                print("JSON Parsing Error: \(error)")
//            }
//        }
//        return nil
//    }

    
    public  func trackEvent(eventId: String, snipeId: String, transactionAmount: Int? = nil, partialPercentage: Int? = nil) async -> Any {
        guard let apiKey = _apiKey else {
            print("API Key not initialized.")
            return ""
        }
        
        let requestBody = buildRequestBody(eventId: eventId, transactionAmount: transactionAmount, partialPercentage: partialPercentage)
        
        do {
            let apiService = ApiService()
            let response = try await apiService.post(endpoint: "events/trigger-event", requestBody: requestBody, headers: ["x-api-key": apiKey, "x-user-id": snipeId])
            
//            print("POST Response: \(response)")
            return response
        } catch {
            print("POST Request failed: \(error)")
            return ""
        }
        
    }

    
    public func getTokenHistory(snipeId: String) async -> Any {
        guard let apiKey = _apiKey else {
            print("API Key not initialized.")
            return ""
        }

        do {
            let apiService = ApiService()
            let response = try await apiService.get(endpoint: "token-management/read-token-user-history", headers: ["x-api-key": apiKey, "x-user-id": snipeId])
            
//            print("GET token Response: \(response)")
            
            return response
        } catch {
            print("GET token Request failed: \(error)")
            return ""
        }
    }

    
    public func getTokenDetails(snipeId: String) async -> Any {
        guard let apiKey = _apiKey else {
            print("API Key not initialized.")
            return ""
        }

        do {
            let apiService = ApiService()
            let response = try await apiService.get(endpoint: "token-management/get-all-client-tokens", headers: ["x-api-key": apiKey, "x-user-id": snipeId])
            
//            print("GET token Response: \(response)")
            
            return response
        } catch {
//            print("GET token Request failed: \(error)")
            return ""
        }
    }

    
   

   


    public func getCoinData(snipeId: String) async -> Any {
        guard let apiKey = _apiKey else {
            print("API Key not initialized. Call init() first.")
            return ""
        }

        let apiService = ApiService()

        do {
            let response = try await apiService.get(endpoint: "token-management/get-user-tokens", headers: ["x-api-key": apiKey, "x-user-id": snipeId])
//            print("GET Response: \(response)")
            return response
        } catch {
            print("GET Request failed with error: \(error)")
            return ""
        }
    }


    
}

private func buildRequestBody(eventId: String, transactionAmount: Int?, partialPercentage: Int?) -> [String:Any] {
    var body: [String: Any] = ["event_id": eventId]

        body["transaction_value"] = transactionAmount
   
        body["partial_percentage"] = partialPercentage
    

    return body
}
