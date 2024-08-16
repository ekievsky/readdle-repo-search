//
//  RepositoryDetailsScreen.swift
//  ReaddleRepoSearch
//
//  Created by Yevhen Kyivskyi on 16.08.2024.
//

import SwiftUI

struct RepositoryDetailsScreen: View {
    
    private let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: repository.owner.avatarUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 42, height: 42)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(repository.name)
                        .font(.title3)
                    Text(repository.description)
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                }
                Spacer(minLength: 8)
            }
            Text("Language: ")
                .font(.subheadline) +
            Text(repository.language ?? "N/A")
                .font(.subheadline)
            
            Text("Owner type: ")
                .font(.subheadline) +
            Text(repository.owner.type)
                .font(.subheadline)
            
            Text("Owner username: ")
                .font(.subheadline) +
            Text(repository.owner.login)
                .font(.subheadline)
            Spacer()
        }
        .padding()
    }
    
    init(repository: Repository) {
        self.repository = repository
    }
}

#Preview {
    RepositoryDetailsScreen(repository: .init(id: 1, name: "name", description: "desc", language: "", owner: .init(id: 1, login: "", type: "", avatarUrl: "")))
}
