//
//  NetworkManager.swift
//  ReaddleRepoSearch
//
//  Created by Yevhen Kyivskyi on 16.08.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let securedStorage: SecuredStoring
    
    init(securedStorage: SecuredStoring = SecuredStorage()) {
        self.securedStorage = securedStorage
    }
    
    func request<T: Decodable>(_ request: Request, isAnonymous: Bool = true) async throws -> T {
        do {
            var urlRequest = try request.asURLRequest()
            
            urlRequest.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
            urlRequest.setValue("Bearer \(securedStorage.getToken())", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedResponse = try decoder.decode(T.self, from: data)
                return decodedResponse
            } catch let decodingError {
                throw NetworkError.decodingFailed(decodingError)
            }
        } catch let error {
            throw NetworkError.requestFailed(error)
        }
    }
}
