import Moya
import Foundation

    // Сервис аутентификации
class AuthService {
    static let shared = AuthService()
    private let provider = MoyaProvider<AuthAPI>()
    

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.login(email: email, password: password)) { result in

            switch result {
            case .success(let response):
                do {
                    // Преобразуем ответ в строку для отладки
                    let responseString = String(data: response.data, encoding: .utf8)
                    print("Ответ от сервера:\n\(responseString ?? "Не удалось получить ответ")")
                    
                    // Проверяем, что ответ — это строка (токен)
                    if let token = responseString, token.count > 10 {
                        TokenManager.shared.token = token

                        completion(.success(token))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Токен не найден"])))
                    }
                    
                } catch {
                    print("Ошибка декодирования: \(error.localizedDescription)")
                    completion(.failure(error))
                }


            case .failure(let error):
                print("Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

//    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
//        provider.request(.login(email: email, password: password)) { result in
//            switch result {
//            case .success(let response):
//                let responseString = String(data: response.data, encoding: .utf8) ?? "Не удалось декодировать ответ"
//                if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
//                    print("Ответ в формате JSON: \(json)")  // Логируем ответ в JSON
//                }
//                
//                // Проверка токена, если он есть
//                do {
//                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: response.data)
//                    TokenManager.shared.token = loginResponse.token
//                    completion(.success(loginResponse.token))
//                } catch {
//                    print("Ошибка декодирования: \(error.localizedDescription)")
//                    completion(.failure(error))
//                } 
//            case .failure(let error):
//                print("Ошибка запроса: \(error.localizedDescription)")
//                completion(.failure(error))
//            }
//        }
//    }



    
    
    func subscribe(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.subscribeToNotifications(email: email)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: [])
                    print("Success:", json)
                } catch {
                }
            case .failure(let error):
                print("Request failed:", error.localizedDescription)
            }
        }
    }
    
    func register(username: String, password: String, email: String, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.register(username: username, email: email, password: password)) { result in
            switch result {
            case .success(let response):
                do {
                    let responseData = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    if let message = responseData?["message"] as? String {
                        completion(.success(message))
                    } else {
                        completion(.success("Registration successful"))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func activateAccount(code: Int, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.activate(code: code)) { result in
            switch result {
            case .success(let response):
                let responseText = String(data: response.data, encoding: .utf8) ?? "No data"
                
                if response.statusCode == 200 {
                    if responseText.contains("Неверный") || responseText.contains("устаревший") {
                        // Сервер вернул 200, но с сообщением об ошибке
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [
                            NSLocalizedDescriptionKey: responseText
                        ])))
                    } else {
                        completion(.success(responseText))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [
                        NSLocalizedDescriptionKey: "Activation failed with status code \(response.statusCode)"
                    ])))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        provider.request(.getCurrentUser) { result in
            switch result {
            case .success(let response):
                print("✅ Status code:", response.statusCode)
                
                guard (200..<300).contains(response.statusCode) else {
                    print("❌ Server returned error status: \(response.statusCode)")
                    print("❌ Response body:", String(data: response.data, encoding: .utf8) ?? "no body")
                    completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [
                        NSLocalizedDescriptionKey: "Request failed with status \(response.statusCode)"
                    ])))
                    return
                }
                
                if response.data.isEmpty {
                    print("⚠️ Empty response from server")
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [
                        NSLocalizedDescriptionKey: "Empty response from server"
                    ])))
                    return
                }
                
                do {
                    let jsonString = String(data: response.data, encoding: .utf8) ?? "Unreadable"
//                    print("📦 Raw JSON:", jsonString)
                    
                    let user = try JSONDecoder().decode(User.self, from: response.data)
                    
                    // ✅ Сохраняем пользователя
                    UserManager.shared.currentUser = user
                    
                    completion(.success(user))
                }
                catch {
//                    print("❌ Decoding failed:", error)
//                    print("📦 Raw response again:", String(data: response.data, encoding: .utf8) ?? "Unreadable")
                    completion(.failure(error))
                }
                
            case .failure(let error):
//                print("❌ Request failed:", error)
                completion(.failure(error))
            }
        }
    }


    func updateUser(updatedUser: User, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.updateUser(id: updatedUser.id!, user: updatedUser)) { result in
            switch result {
            case .success(let response):
                do {
                    // Пробуем распарсить ответ как JSON
                    if let jsonObject = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                        // Проверяем, что данные пришли и что их формат правильный
                        if let id = jsonObject["id"] as? Int {
                            print("✅ User updated successfully with ID: \(id)")
                            completion(.success("User updated successfully"))
                        } else {
                            print("⚠️ Unexpected response format:", jsonObject)
                            completion(.failure(NSError(domain: "", code: -1, userInfo: [
                                NSLocalizedDescriptionKey: "Unexpected response format"
                            ])))
                        }
                    }
                } catch {
                    print("❌ JSON parsing error:", error)
                    completion(.failure(error))
                }

            case .failure(let error):
                print("❌ Request failed:", error.localizedDescription)
                completion(.failure(error))
            }
        }
    }


       // Парсим ответ в модель пользователя
//       func parseUserResponse(_ response: [String: Any]) -> User? {
//           var user = User()
//
//           user.id = response["id"] as? Int ?? 0
//           user.username = response["username"] as? String
//           user.password = response["password"] as? String
//           user.email = response["email"] as? String
//           user.firstName = response["firstName"] as? String
//           user.lastName = response["lastName"] as? String
//           user.role = response["role"] as? String
//           user.status = response["status"] as? String
//           user.telephone = response["telephone"] as? String
//           user.userProfileImageUrl = response["userProfileImageUrl"] as? String == "<null>" ? nil : response["userProfileImageUrl"] as? String
//
//           return user
//       }

}
