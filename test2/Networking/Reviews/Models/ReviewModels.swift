//
//  ReviewModels.swift
//  test2
//
//  Created by Dias Karassayev on 4/25/25.
//

import Foundation

struct Forum: Decodable {
    let id: Int
    let name: String
    let description: String
    let universityId: Int
    let universityImgUrl: String?
    let forumPicture: String?
    let topReviews: [TopReview]
}

struct TopReview: Decodable {
    let id: Int
    let forumId: Int
    let forumName: String?
    let comment: String
    let rating: Int
    let userId: Int
    let userName: String?
    let createdAt: String?
    let updatedAt: String?
    let status: String
    let likes: Int
    let dislikes: Int
    let attachments: String?
    let comments: String?
    let profileImgUrl: String?
}
