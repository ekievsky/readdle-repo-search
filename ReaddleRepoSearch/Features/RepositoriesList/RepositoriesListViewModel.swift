//
//  RepositoriesListViewModel.swift
//  ReaddleRepoSearch
//
//  Created by Yevhen Kyivskyi on 16.08.2024.
//

import Foundation

@MainActor class RepositoriesListViewModel: ObservableObject {
    
    private let repositoryService: RepositoryServicing
    
    @Published var searchText: String = ""
    @Published var isSearching = false
    @Published var isShowingErrorAlert = false
    @Published var errorMessage: String?
    
    @Published var repositories: [Repository] = []
    
    private var ongoingTasks: [Task<(), Never>] = []
    private var cancelBag = CancelBag()
    
    init(repositoryService: RepositoryServicing = RepositoryService()) {
        self.repositoryService = repositoryService
        
        $searchText
            .filter { !$0.isEmpty }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.search(query: query)
            }
            .store(in: &cancelBag)
            
    }
    
    func search(query: String) {
        prepareForTask()
        
        let searchTask = makeSearchTask(query: query)
        ongoingTasks.append(searchTask)
        Task { @MainActor in
            searchTask
        }
    }
    
    func clearQuery() {
        searchText = ""
        repositories = []
    }
}


private extension RepositoriesListViewModel {
    
    func prepareForTask() {
        ongoingTasks.forEach { $0.cancel() }
        ongoingTasks.removeAll()
    }
    
    func makeSearchTask(query: String) -> Task<(), Never> {
        return Task { @MainActor in
            isSearching = true
            
            do {
                let response: [Repository] = try await repositoryService.search(query: query)
                repositories = response
                isSearching = false
            } catch {
                isShowingErrorAlert = true
                errorMessage = error.localizedDescription
                isSearching = false
            }
        }
    }
}
