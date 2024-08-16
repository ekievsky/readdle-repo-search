//
//  RepositoryService.swift
//  ReaddleRepoSearch
//
//  Created by Yevhen Kyivskyi on 16.08.2024.
//

import Foundation

protocol RepositoryServicing {
    func search(query: String?) async throws -> [Repository]
}

class RepositoryService: RepositoryServicing {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func search(query: String?) async throws -> [Repository] {
        guard let query else {
            return []
        }
        
        let response: SearchRepositoriesResponse =  try await networkManager.request(.search(query: query))
        
        return response.items
    }
}
