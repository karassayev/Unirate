//
//  UniversitiesService.swift
//  test2
//
//  Created by Dias Karassayev on 4/2/25.
//
import Foundation
import Moya

class UniversityService {
    private let provider = MoyaProvider<UniversityAPI>()
    
    // Получить топ университетов
    func fetchTopUniversities(limit: Int, completion: @escaping (Result<[University], Error>) -> Void) {
        provider.request(.getTopUniversities(limit: limit)) { result in
            switch result {
            case .success(let response):
                do {
                    let universities = try JSONDecoder().decode([University].self, from: response.data)
                    completion(.success(universities))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Получить все университеты
    func fetchAllUniversities(completion: @escaping (Result<[University], Error>) -> Void) {
        provider.request(.getAllUniversities) { result in
            switch result {
            case .success(let response):
                do {
                    let universities = try JSONDecoder().decode([University].self, from: response.data)
                    completion(.success(universities))
                } catch {
                    print("❌ Ошибка декодирования: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ Ошибка сети: \(error)")
                completion(.failure(error))
            }
        }
    }
    func search(searchField: String? = nil, city: String? = nil, minTuition: Int? = nil, maxTuition: Int? = nil, hasMilitaryDepartment: Bool? = nil, hasDormitory: Bool? = nil, completion: @escaping (Result<[University], Error>) -> Void) {
        provider.request(.search(searchField: searchField, city: city, minTuition: minTuition, maxTuition: maxTuition, hasMilitaryDepartment: hasMilitaryDepartment, hasDormitory: hasDormitory)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(UniversityResponse.self, from: response.data)
                    completion(.success(decoded.content))
                } catch {
                    print(String(data: response.data, encoding: .utf8) ?? "Invalid response")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    func addToFavorites(universityId: Int, userId: Int, completion: @escaping (Result<[University], Error>) -> Void) {
            provider.request(.addToFavorites(universityId: universityId, userId: userId)) { result in
                switch result {
                case .success(let response):
                    print("✅ Университет добавлен в избранное. Status code:", response.statusCode)
                case .failure(let error):
                    print("❌ Ошибка при добавлении в избранное:", error.localizedDescription)
                }
            }
        }
    func removeFromFavorites(universityId: Int, completion: @escaping (Result<[University], Error>) -> Void) {
            provider.request(.removeFromFavorites(universityId: universityId)) { result in
                switch result {
                case .success(let response):
                    print("❎ Университет удален из избранного. Status code:", response.statusCode)
                case .failure(let error):
                    print("❌ Ошибка при удалении из избранного:", error.localizedDescription)
                }
            }
        }
    func getFavorites(userId: Int, completion: @escaping (Result<[University], Error>) -> Void) {
        provider.request(.getFavorites(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let universities = try JSONDecoder().decode([University].self, from: response.data)
                    completion(.success(universities))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


}

