import Moya
import Foundation

enum AuthAPI {
    case login(email: String, password: String)
    case register(username: String, email: String, password: String)
    case activate(code: Int)
    case subscribeToNotifications(email: String)
    case getCurrentUser
    case updateUser(id: Int, user: User)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8087/registry")!
    }

    var path: String {
        switch self {
        case .login:
            return "/open-api/auth/login"
        case .register:
            return "/open-api/auth/register"
        case .activate:
            return "/open-api/auth/activation"
        case .subscribeToNotifications:
            return "/open-api/notifications/subscribe"
        case .getCurrentUser:
            return "/api/user/current"
        case .updateUser(let id, _):
            return "/api/user/\(id)/update"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .register, .activate, .subscribeToNotifications, .updateUser:
            return .post
        case .getCurrentUser:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .login(email, password):
            return .requestParameters(
                parameters: ["email": email, "password": password],
                encoding: JSONEncoding.default
            )
        case let .register(username, email, password):
            return .requestParameters(
                parameters: ["username": username, "email": email, "password": password],
                encoding: JSONEncoding.default
            )
        case let .activate(code):
            return .requestParameters(parameters: ["code": code], encoding: URLEncoding.queryString)
        case let .subscribeToNotifications(email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
        case .getCurrentUser:
            return .requestPlain
        case let .updateUser(_, user):
            var parameters: [String: Any] = ["id": user.id]
            if let username = user.username { parameters["username"] = username }
            if let password = user.password { parameters["password"] = password }
            if let email = user.email { parameters["email"] = email }
            if let firstName = user.firstName { parameters["firstName"] = firstName }
            if let lastName = user.lastName { parameters["lastName"] = lastName }
            if let role = user.role { parameters["role"] = role }
            if let telephone = user.telephone { parameters["telephone"] = telephone }
            if let status = user.status { parameters["status"] = status }
            if let userProfileImageUrl = user.userProfileImageUrl { parameters["userProfileImageUrl"] = userProfileImageUrl }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        var defaultHeaders = [
            "Content-Type": "application/json",
            "accept": "*/*"
        ]
        // ❌ Добавлять Authorization только если не login/register
        switch self {
        case .login, .register:
            return defaultHeaders
        default:
            if let token = TokenManager.shared.token {
                defaultHeaders["Authorization"] = "Bearer \(token)"
            }
            return defaultHeaders
        }
    }

}
