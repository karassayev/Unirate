//
//  ReviewAPI.swift
//  test2
//
//  Created by Dias Karassayev on 4/25/25.
//

import Moya
import Foundation

enum ForumAPI {
    case getForums
}

extension ForumAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8082")!
    }

    var path: String {
        switch self {
        case .getForums:
            return "/university/open-api/forums"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return ["accept": "*/*"]
    }
}
