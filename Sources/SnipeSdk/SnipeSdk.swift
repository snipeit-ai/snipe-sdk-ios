import Foundation

public struct SnipeSdk {
    private var _apiKey: String?
    public init(apiKey:String) {
        _apiKey=apiKey
        
    }
    
    public func signUp(hash: String) -> String {
        guard let apiKey = _apiKey else {
            print("API Key not initialized.")
            return ""
        }
        var output:String="";
        
        let apiService = ApiService()
        apiService.post(endpoint: "users",requestBody:["hash": hash],  headers: ["x-api-key":apiKey]) { response in
            if let response = response {
                print("POST Response: \(response)")
                output=parseSnipeId(jsonResponse: response) ?? "";
                
            } else {
                print("POST Request failed")
            }
        }
           return output
       }
   private func parseSnipeId(jsonResponse: String) -> String? {
        if let data = jsonResponse.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataObject = json["data"] as? [String: Any],
                   let valueObject = dataObject["value"] as? [String: Any],
                   let snipeId = valueObject["snipe_id"] as? String {
                    return snipeId
                }
            } catch {
                print("JSON Parsing Error: \(error)")
            }
        }
        return nil
    }

    
    public func trackEvent(eventId: String,snipeId: String, transactionAmount: Int? = nil, partialPercentage: Int? = nil)  {
        guard let apiKey = _apiKey else {
            print("API Key not initialized.")
            return
        }

       let requestBody = buildRequestBody(eventId: eventId, transactionAmount: transactionAmount, partialPercentage: partialPercentage)

        let apiService = ApiService()
        apiService.post(endpoint: "trigger-event", requestBody: requestBody, headers: ["x-api-key":apiKey,"x-user-id":snipeId]) { response in
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
        apiService.get(endpoint: "get-user-tokens",headers: ["x-api-key":apiKey,"x-user-id":snipeId] ) { response in
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

private func buildRequestBody(eventId: String, transactionAmount: Int?, partialPercentage: Int?) -> [String:Any] {
    var body: [String: Any] = ["eventId": eventId]

        body["transactionAmount"] = transactionAmount
   
        body["partialPercentage"] = partialPercentage
    

   

    return body
}

