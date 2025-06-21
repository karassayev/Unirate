//
//  ReviewService.swift
//  test2
//
//  Created by Dias Karassayev on 4/25/25.
//

import Foundation
import Moya

class ReviewService {
    private let provider = MoyaProvider<ForumAPI>()

    func fetchForums(completion: @escaping (Result<[Forum], Error>) -> Void) {
        provider.request(.getForums) { result in
            switch result {
            case .success(let response):
                do {
                    let forums = try JSONDecoder().decode([Forum].self, from: response.data)
                    completion(.success(forums))
                } catch {
                    print("❌ Ошибка декодирования форумов: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ Ошибка сети при получении форумов: \(error)")
                completion(.failure(error))
            }
        }
    }
}
