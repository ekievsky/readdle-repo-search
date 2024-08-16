//
//  RepositoriesListScreen.swift
//  ReaddleRepoSearch
//
//  Created by Yevhen Kyivskyi on 16.08.2024.
//

import SwiftUI

struct RepositoriesListScreen: View {
    
    @StateObject private var viewModel = RepositoriesListViewModel()
    
    var body: some View {
        NavigationView {
            contentView
        }
    }
}

private extension RepositoriesListScreen {
    
    var contentView: some View {
        List {
            searchView
            ForEach(viewModel.repositories, id: \.self) { repository in
                NavigationLink(destination: RepositoryDetailsScreen(repository: repository)) {
                    makeItemView(repository: repository)
                }
            }
        }
        .alert(
            viewModel.errorMessage ?? "Something went wrong, please try again",
            isPresented: $viewModel.isShowingErrorAlert
        ) {
            Button("OK", role: .cancel) { }
        }
        .navigationTitle("Repo search")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var searchView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 16, height: 16)
            TextField("Query", text: $viewModel.searchText)
            if !viewModel.searchText.isEmpty && !viewModel.isSearching {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .onTapGesture {
                        viewModel.clearQuery()
                    }
            }
            if viewModel.isSearching {
                ProgressView()
                    .frame(width: 16, height: 16)
            }
        }
    }
    
    func makeItemView(repository: Repository) -> some View {
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
                    .lineLimit(2)
            }
            Spacer(minLength: 8)
        }
    }
}

#Preview {
    RepositoriesListScreen()
}
