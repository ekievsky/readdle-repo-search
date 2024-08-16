//
//  Request.swift
//  ReaddleRepoSearch
//
//  Created by Yevhen Kyivskyi on 16.08.2024.
//

import Foundation

enum Request {

    case search(query: String)
    
    var route: String {
        switch self {
        case .search(let query):
            return "search/repositories?q=\(query)&per_page=10"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .search:
            return "GET"
        }
    }
}

extension Request {
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: "https://api.github.com/\(route)") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
