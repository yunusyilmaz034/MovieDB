//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.d.
//

import Foundation

class SearchViewModel {
    
    //MARK:- Properties
    private let apiClient: APIClient
    private (set) var state: Bindable<FetchingServiceState> = Bindable(.loading)
    private (set) var searchResult: Bindable<[Movie]> = Bindable([])
    private (set) var searchMode = false
    private (set) var currentPage: Int = 1
    private (set) var totalPages: Int = Int.max
    private (set) var currentQuery: String?
    private var searchWaitTimer: Timer?

    //MARK:- init
    //init SearchViewModel with dependency injection of network server client object
    //to be able to mock the network layer for unit testing
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    //MARK:- Methods
    func search(query: String) {
        if currentQuery != query {
            resetValues()
            currentQuery = query
        }
        if currentPage > totalPages { return }
        state.value = .loading
        let parameters = [NetworkConstants.queryParameterKey: query, NetworkConstants.pageParameterKey: "\(currentPage)"]
        apiClient.searchMovies(service: SearchAPI(paramters: parameters), completion: { [weak self] response in
            self?.state.value = .finishedLoading
            switch response {
            case .success(let result):
                self?.searchResult.value.append(contentsOf: result.movies)
                self?.totalPages = result.totalPages
                self?.currentPage += 1
            case .failure(let error):
                self?.state.value = .error(error)
            }
        })
    }

    func searchTextChanged(query: String?) {
        if query == nil || query?.isEmpty == true {
            stopSearchTimer()
            searchMode = false
        } else {
            searchMode = true
            startSearchTimer(query: query ?? "")
        }
    }

    func searchDidBeginEditing(query: String?) {
        if query == nil || query?.isEmpty == true {
            resetSearch()
        }
    }
    
    func resetSearch() {
        searchMode = false
        resetValues()
    }

    //MARK:- Helpers
    private func resetValues() {
        currentPage = 1
        totalPages = Int.max
        searchResult.value.removeAll()
    }

    private func stopSearchTimer() {
         searchWaitTimer?.invalidate()
         searchWaitTimer = nil
     }

    private func startSearchTimer(query: String) {
         stopSearchTimer()
         searchWaitTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {[weak self] _ in
             self?.performSearch(query: query)
         })
     }

    private func performSearch(query: String) {
         stopSearchTimer()
         search(query: query)
     }
}
