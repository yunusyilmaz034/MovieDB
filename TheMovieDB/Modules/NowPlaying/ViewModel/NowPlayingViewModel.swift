//
//  NowPlayingViewModel.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation

class NowPlayingViewModel {

    //MARK:- Properties
    private (set) var state: Bindable<FetchingServiceState> = Bindable(.loading)
    private let apiClient: APIClient
    private var searchResponse: SearchResponse?
    private (set) var nowPlayingList: Bindable<[Movie]> = Bindable([])
    private (set) var currentPage: Int = 1
    private (set) var totalPages: Int = Int.max

    //MARK:- init
    //init NowPlayingViewModel with dependency injection of network server client object
    //to be able to mock the network layer for unit testing
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    //MARK:- Helpers
    func fetchNowPlaying() {
        if currentPage > totalPages { return }
        state.value = .loading
        apiClient.getNowPlayingMovies(service: NowPlayingAPI(paramters: [NetworkConstants.pageParameterKey: "\(currentPage)"]), completion: { [weak self] response in
            self?.state.value = .finishedLoading
            switch response {
            case .success(let result):
                self?.nowPlayingList.value.append(contentsOf: result.movies)
                self?.totalPages = result.totalPages
                self?.currentPage += 1
            case .failure(let error):
                self?.state.value = .error(error)
            }
        })
    }
}

