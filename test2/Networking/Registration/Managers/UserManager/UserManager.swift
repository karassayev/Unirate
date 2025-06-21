//
//  UserManager.swift
//  test2
//
//  Created by Dias Karassayev on 4/23/25.
//
import Foundation

class UserManager {
    static let shared = UserManager()

    private let userKey = "currentUser"

    var currentUser: User? {
        get {
            guard let data = UserDefaults.standard.data(forKey: userKey) else { return nil }
            return try? JSONDecoder().decode(User.self, from: data)
        }
        set {
            if let user = newValue {
                let data = try? JSONEncoder().encode(user)
                UserDefaults.standard.set(data, forKey: userKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userKey)
            }
        }
    }

    func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
