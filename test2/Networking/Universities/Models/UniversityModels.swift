////
////  University.swift
////  test2
////
////  Created by Dias Karassayev on 4/3/25.
////
//
//
import Foundation

struct UniversityResponse: Decodable {
    let content: [University]
}

struct University: Decodable {
    let id: Int
    let name: String
    let description: String
    let location: String?
    let rating: Double
    let baseCost: Int
    let ratingCount: Int
    let website: String?
    let contactEmail: String?
    let logoUrl: String?
    let militaryDepartment: Bool
    let dormitory: Bool
    let militaryDepartmentCost: Int?
    let dormitoryCost: Int?
    let universityAddress: UniversityAddress?
    let faculty: [Faculty]

    struct UniversityAddress: Decodable {
        let id: Int
        let city: String
        let region: String
        let fullAddress: String
        let universityId: Int
    }
}

struct Faculty: Decodable {
    let facultyDto: FacultyDetails
    let specialtyDtos: [Specialty]

    struct FacultyDetails: Decodable {
        let id: Int
        let name: String
        let description: String
        let contactEmail: String
        let contactPhoneNumber: String
        let baseCost: Int
    }
}

struct Specialty: Decodable {
    let id: Int
    let name: String
    let description: String
    let facultyId: Int
    let specialtyImageUrl: String?
    let facultyName: String?
    let universityName: String?
    let gopCode: String?
    let grants: String?
    let minScores: String?
    let courses: [Course]?

    enum CodingKeys: String, CodingKey {
        case id, name, description, facultyId, specialtyImageUrl, facultyName, universityName, gopCode, grants, minScores, courses
    }
}



struct Course: Decodable {
    let id: Int
    let name: String
    let description: String
    let durationYears: Int
    let language: String
    let tuitionFee: Int
    let studyMode: String
    let requirements: String?
}

struct UniversityCost {
    var educationCost: Int
    var dormitoryCost: Int?
    var militaryCost: Int?
    var total: Int
}
