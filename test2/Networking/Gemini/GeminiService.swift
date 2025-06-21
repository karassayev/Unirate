//
//  GeminiService.swift
//  test2
//
//  Created by Dias Karassayev on 4/14/25.
//

import Foundation
import Moya

final class GeminiService {
    
    private let provider = MoyaProvider<GeminiAPI>()
    
    func sendPrompt(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.generateContent(prompt: prompt)) { result in
            switch result {
            case .success(let response):
                print(String(data: response.data, encoding: .utf8) ?? "no data")
                do {
                    if let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any] {
                        
                        // Handle API error response
                        if let error = json["error"] as? [String: Any],
                           let message = error["message"] as? String {
                            let code = error["code"] as? Int ?? 0
                            completion(.failure(NSError(domain: "APIError", code: code, userInfo: [NSLocalizedDescriptionKey: message])))
                            return
                        }
                        
                        // Handle successful response
                        if let candidates = json["candidates"] as? [[String: Any]],
                           let content = candidates.first?["content"] as? [String: Any],
                           let parts = content["parts"] as? [[String: Any]],
                           let reply = parts.first?["text"] as? String {
                            completion(.success(reply))
                        } else {
                            completion(.failure(NSError(domain: "ParseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response."])))
                        }
                    } else {
                        completion(.failure(NSError(domain: "ParseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure."])))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
