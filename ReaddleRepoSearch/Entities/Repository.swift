//
//  Repository.swift
//  ReaddleRepoSearch
//
//  Created by Yevhen Kyivskyi on 16.08.2024.
//

import Foundation

struct Repository: Codable {
    
    let id: Int
    let name: String
    let description: String
    let language: String?
    
    let owner: RepositoryOwner
}


extension Repository: Hashable {}
