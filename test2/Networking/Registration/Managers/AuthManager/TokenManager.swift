//
//  TokenManager.swift
//  test1
//
//  Created by Dias Karassayev on 3/3/25.
//
import Foundation

class TokenManager {
    static let shared = TokenManager()

    private let tokenKey = "authToken"

    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }

    func clearToken() {
        token = nil
    }
}
