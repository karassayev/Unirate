////
////  Models.swift
////  test1
////
////  Created by Dias Karassayev on 3/3/25.
////
import Foundation

struct LoginResponse: Codable {
    let token: String
    let user: User  // Include user details in response
}
struct User: Codable {
    var id: Int?
    var username: String?
    var password: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var role: String?
    var telephone: String?
    var status: String?
    var userProfileImageUrl: String?
}
