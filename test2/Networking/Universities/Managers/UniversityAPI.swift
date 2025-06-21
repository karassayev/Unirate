//
//  UniversityAPI.swift
//  test2
//
//  Created by Dias Karassayev on 4/3/25.
//

import Foundation
import Moya

enum UniversityAPI {
    case getTopUniversities(limit: Int)
    case getAllUniversities
    case search(searchField: String?, city: String?, minTuition: Int?, maxTuition: Int?, hasMilitaryDepartment: Bool?, hasDormitory: Bool?)
    case addToFavorites(universityId: Int, userId: Int)
    case removeFromFavorites(universityId: Int)
    case getFavorites(userId: Int)

}

extension UniversityAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8082/university/open-api")!
    }


    var path: String {
        switch self {
        case .getTopUniversities:
            return "/universities/top"
        case .getAllUniversities:
            return "/universities"
        case .search:
            return "/universities/search"
        case .addToFavorites:
            return "/favorites"
        case .removeFromFavorites(let universityId):
            return "/favorites/\(universityId)"
        case .getFavorites(let userId):
            return "/favorites/\(userId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getAllUniversities, .getTopUniversities, .getFavorites:
            return .get
        case .search, .addToFavorites:
            return .post
        case .removeFromFavorites:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .getTopUniversities(let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        case .getAllUniversities:
            return .requestPlain
        case .search(let searchField, let city, let minTuition, let maxTuition, let hasMilitaryDepartment, let hasDormitory):
            var parameters: [String: Any] = [
                "searchField": searchField
            ]
            
            if let city = city { parameters["city"] = city }
            if let minTuition = minTuition { parameters["minTuition"] = minTuition }
            if let maxTuition = maxTuition { parameters["maxTuition"] = maxTuition }
            if let hasMilitaryDepartment = hasMilitaryDepartment { parameters["hasMilitaryDepartment"] = hasMilitaryDepartment }
            if let hasDormitory = hasDormitory { parameters["hasDormitory"] = hasDormitory }
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .addToFavorites(universityId, userId):
            let body: [String: Any] = [
                "universityId": universityId,
                "userId": userId
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)
        case .removeFromFavorites:
            return .requestPlain
        case .getFavorites:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["accept": "application/json"]
    }
}
