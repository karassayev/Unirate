//
//  Untitled.swift
//  test2
//
//  Created by Dias Karassayev on 4/14/25.
//

import Moya
import Foundation


enum GeminiAPI {
    case generateContent(prompt: String)
}

extension GeminiAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://generativelanguage.googleapis.com/v1beta/")!
    }

    var path: String {
        switch self {
        case .generateContent:
            return "models/gemini-1.5-flash:generateContent"
        }
    }
    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case .generateContent(let prompt):
            let body: [String: Any] = [
                "contents": [
                    [
                        "parts": [
                            ["text": prompt]
                        ]
                    ]
                ]
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "x-goog-api-key": "AIzaSyACm8bLw_eqdmVVyFo6jvqihjd-M7jJnD0"
        ]
    }

    var sampleData: Data {
        return Data()
    }
}
