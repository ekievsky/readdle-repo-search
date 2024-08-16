//
//  SecuredStorage.swift
//  ReaddleRepoSearch
//
//  Created by Yevhen Kyivskyi on 16.08.2024.
//

import Foundation

protocol SecuredStoring {
    func getToken() -> String
}

class SecuredStorage: SecuredStoring {
    func getToken() -> String {
        "secret"
    }
}
