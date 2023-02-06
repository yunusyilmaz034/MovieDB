//
//  NowPlayingColViewController.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import UIKit
import CoreData

class NowPlayingColViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var featureColView: UICollectionView!
    @IBOutlet weak var featurePager: UIPageControl!
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listColConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchListConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabbar: UITabBar!
    
    //MARK:- Variables
    private var viewModel: NowPlayingViewModel?
    private var searchViewModel: SearchViewModel?
    var coordinatorDelegate: NowPlayingCoordinatorDelegate?
    var persistenceManager: PersistenceManager
    var movieFavorite: [Movie]?
    
    init(viewModel: NowPlayingViewModel, searchViewModel: SearchViewModel, persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        super.init(nibName: String(describing: NowPlayingColViewController.self), bundle: nil)
        self.viewModel = viewModel
        self.searchViewModel = searchViewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel?.fetchNowPlaying()
    }
    override func viewDidAppear(_ animated: Bool) {
        if movieFavorite?.count != getFavMoviesCount(){
            tabbar.items?[1].badgeValue = getFavMovies().description
        }
    }

    //MARK:- Helpers
    private func setupView() {
        featurePager.currentPage = 0
        tabbar.selectedItem = tabbar.items?.first
        setupNavigation()
        setUpCollectionView()
    }

    private func setupNavigation() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "tmdb"))
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setUpCollectionView() {
        featureColView.register(UINib(nibName: FeatureColViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: FeatureColViewCell.cellIdentifier)
        colView.register(UINib(nibName: MovieColCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MovieColCell.cellIdentifier)
        colView.register(UINib(nibName: EmptyDataColCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: EmptyDataColCell.cellIdentifier)
        colView.register(UINib(nibName: LoadindColCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: LoadindColCell.cellIdentifier)
    }

    //MARK:- Data binding
    private func bindViewModel() {
        viewModel?.nowPlayingList.bind {[weak self] _ in
            DispatchQueue.main.async {
              //  self?.featureColView?.reloadData()
                self?.colView?.reloadData()
            }
        }
        viewModel?.state.bind({[weak self] state in
            switch state {
            case .error(let error):
                self?.presentNetworkError(error: error)
            case .loading, .finishedLoading:
                break
            }
        })

        searchViewModel?.searchResult.bind {[weak self] _ in
            DispatchQueue.main.async {
                self?.colView?.reloadData()
            }
        }

        searchViewModel?.state.bind({[weak self] state in
            switch state {
            case .error(let error):
                self?.presentNetworkError(error: error)
            case .loading, .finishedLoading:
                break
            }
        })
    }
}
extension NowPlayingColViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 0 {
            return 1
        }
        if searchViewModel?.searchMode == true {
            guard let searchVM = searchViewModel else { return 2 }
            return searchVM.currentPage > searchVM.totalPages ? 1 : 2 // 2nd section for search of infinite scrolling while total pages not reached
        } else {
            guard let viewModel = viewModel else { return 2 }
            return viewModel.currentPage > viewModel.totalPages ? 1 : 2 // 2nd section for now playing of infinite scrolling while total pages not reached
        }
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if collectionView.tag == 0 {
                return 3
            }
            guard
                let movieList = searchViewModel?.searchMode == true ? searchViewModel?.searchResult.value : viewModel?.nowPlayingList.value,
                let state = searchViewModel?.searchMode == true ? searchViewModel?.state.value : viewModel?.state.value else { return 0 }
            return (movieList.count == 0 && state != .loading) ? 1: movieList.count // 1 for the empty data cell only if its not loading
        } else if section == 1 {
            return 1 // For infinite loading cell
        } else {
            return 0
        }
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let movieList = searchViewModel?.searchMode == true ? searchViewModel?.searchResult.value : viewModel?.nowPlayingList.value else { return UICollectionViewCell() }
            if movieList.count > 0 {
                if collectionView.tag == 0 {
                    if let cell1 = featureColView.dequeueReusableCell(withReuseIdentifier: FeatureColViewCell.cellIdentifier, for: indexPath) as? FeatureColViewCell  {
                        cell1.movie = movieList[indexPath.row]
                        return cell1
                    }
                } else if collectionView.tag == 1 {
                    if let cell2 = colView.dequeueReusableCell(withReuseIdentifier: MovieColCell.cellIdentifier, for: indexPath) as? MovieColCell {
                        if movieList.count > indexPath.row + 3 {
                            cell2.movie = movieList[indexPath.row + 3]
                        }
                       
                        cell2.layer.cornerRadius = 6.0
                        cell2.layer.masksToBounds = true
                        return cell2
                    }
                }
                return UICollectionViewCell()
            } else {
                guard let cell = colView.dequeueReusableCell(withReuseIdentifier: EmptyDataColCell.cellIdentifier, for: indexPath) as? EmptyDataColCell else { return UICollectionViewCell() }
                cell.emptyMessageLabel.text = searchViewModel?.searchMode == true ? "No search results for \"\(searchViewModel?.currentQuery ?? "")\"" : "There are no currently playing movies"
                return cell
            }
        } else {
            guard let cell = colView.dequeueReusableCell(withReuseIdentifier: LoadindColCell.cellIdentifier, for: indexPath) as? LoadindColCell else { return UICollectionViewCell() }
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) && viewModel?.state.value != .loading {
            if searchViewModel?.searchMode == true {
                guard let searchText = searchBar.text else { return }
                searchViewModel?.search(query: searchText)
            } else {
                viewModel?.fetchNowPlaying()
            }
        }
    }

    // MARK: UICollectionViewDelegate

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colView.deselectItem(at: indexPath, animated: true)
        guard let movieList = searchViewModel?.searchMode == true ? searchViewModel?.searchResult.value : viewModel?.nowPlayingList.value else { return }
        if collectionView.tag == 1 {
            coordinatorDelegate?.movieSelected(movie: movieList[indexPath.row + 3])
        } else {
            let movie = movieList[indexPath.row]
            coordinatorDelegate?.movieSelected(movie: movie)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            featurePager.currentPage = indexPath.row
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension NowPlayingColViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let size = featureColView.frame.size
            return CGSize(width: size.width, height: size.height)
        }
        return CGSize(width: 414, height: 169) // default MovieCol Cell
    }
    
}
//MARK:- UISearchBarDelegate
extension NowPlayingColViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel?.searchTextChanged(query: searchBar.text)
        if searchViewModel?.searchMode == false {
            colView.reloadData()
        } else {
            featureColView.isHidden = true
            featurePager.isHidden = true
            listColConstraint.priority = UILayoutPriority(rawValue: 750)
            searchListConstraint.constant = 20
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        featureColView.isHidden = false
        featurePager.isHidden = false
        listColConstraint.priority = UILayoutPriority(rawValue: 1000)
        searchListConstraint.constant = 306
        searchViewModel?.searchDidBeginEditing(query: searchBar.text)
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        featureColView.isHidden = false
        featurePager.isHidden = false
        listColConstraint.priority = UILayoutPriority(rawValue: 1000)
        searchListConstraint.constant = 306
        searchViewModel?.resetSearch()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
//MARK:- UITabBarDelegate
extension NowPlayingColViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            tabBar.items?[1].badgeValue = self.getFavMovies().description
            coordinatorDelegate?.tabFavSelected(movies: self.movieFavorite!)
            tabbar.selectedItem = tabbar.items?.first
        }
    }
}
//MARK: - Core DATA
extension NowPlayingColViewController {
    func getFavMovies() -> Int {
        guard let favMovie = try! persistenceManager.context.fetch(MovieFavorite.fetchRequest()) as? [MovieFavorite] else {return 0}
        var count = 0
        for movi in favMovie {
            if count == 0 {
                self.movieFavorite = [Movie(id: Int(movi.moveId), title: movi.title!, overview: movi.overview!, poster: movi.poster!, voteAverage: Decimal(string: movi.voteAverage!)!)]
            } else {
                self.movieFavorite?.append(Movie(id: Int(movi.moveId), title: movi.title!, overview: movi.overview!, poster: movi.poster!, voteAverage: Decimal(string: movi.voteAverage!)!))
            }
            count += 1
        }
        return count
    }
    func getFavMoviesCount() -> Int {
        guard let favMovie = try! persistenceManager.context.fetch(MovieFavorite.fetchRequest()) as? [MovieFavorite] else {return 0}
        return favMovie.count
    }
}
