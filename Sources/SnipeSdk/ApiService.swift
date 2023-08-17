import Foundation

@available(iOS 15.0, *)
internal class ApiService {
    private var baseUrl: String = "https://snipe-sploot-lfvnq7enja-de.a.run.app/api/"

    func get(endpoint: String, headers: [String: String]? = nil) async throws -> String {
        guard let url = URL(string: self.baseUrl + endpoint) else {
            throw NSError(domain: "InvalidURL", code: 0, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let customHeaders = headers {
            for (key, value) in customHeaders {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let responseString = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "ResponseConversionError", code: 0, userInfo: nil)
            }
            
            return responseString
        } catch {
            throw error
        }
    }

    func post(endpoint: String, requestBody: [String: Any], headers: [String: String]? = nil) async throws -> String {
        guard let url = URL(string: self.baseUrl + endpoint) else {
            throw NSError(domain: "InvalidURL", code: 0, userInfo: nil)
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
        } catch {
            throw error
        }

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let responseString = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "ResponseConversionError", code: 0, userInfo: nil)
            }
            
            return responseString
        } catch {
            throw error
        }
    }
}
