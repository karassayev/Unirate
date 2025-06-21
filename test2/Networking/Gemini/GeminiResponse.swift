//
//  GeminiResponse.swift
//  test2
//
//  Created by Dias Karassayev on 4/14/25.
//

import Foundation

//struct GeminiResponse: Decodable {
//    let candidates: [Candidate]
//}
//
//struct Candidate: Decodable {
//    let content: Content
//}
//
//struct Content: Decodable {
//    let parts: [Part]
//}
//
//struct Part: Decodable {
//    let text: String
//}
import Foundation

enum ChatSender {
    case user, gemini
}

struct ChatMessage {
    let text: String
    let sender: ChatSender
    let timestamp: Date
}

