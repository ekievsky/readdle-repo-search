//
//  RepositoryOwner.swift
//  ReaddleRepoSearch
//
//  Created by Yevhen Kyivskyi on 16.08.2024.
//

import Foundation

struct RepositoryOwner: Codable {
    
    let id: Int
    let login: String
    let type: String
    let avatarUrl: String
}

extension RepositoryOwner: Hashable {}
