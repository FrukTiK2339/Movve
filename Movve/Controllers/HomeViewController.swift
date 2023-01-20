//
//  ViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

extension HomeViewController: NetApiFacadeProviderProtocol {
    var netApiFacade: NetApiFacadeProtocol {
        return NetApiFacade.shared
    }
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Private
    private var iconLabel = UILabel()
    private var collectionView: UICollectionView?
    private var sections = [CinemaItemSection]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(occuredLoadingDataError), name: Notification.Name.errorLoadingData, object: nil)

        refreshSections()
        setupCollectionView()
        setupIconLabel()
        setupUI()
    }
    
    private func refreshSections() {
        sections = getSections()
        let indexSet = IndexSet(sections.indices)
        collectionView?.reloadSections(indexSet)
    }
    
    @objc private func handleEnterForeground() {
        refreshSections()
    }
    
    @objc private func occuredLoadingDataError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Loading Failed", message: "Please check your Internet connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default) { _ in
                self.refreshSections()
            })
            self.present(alert, animated: true)
        }
    }
    
    private func getSections() -> [CinemaItemSection] {
        var newSections = [CinemaItemSection]()
        netApiFacade.loadItems(for: .movie, searchType: .popular) { result in
            switch result {
            case .success(let data):
                newSections.append(CinemaItemSection(type: .movie, cells: data))
            case .failure(let error):
                DLog(error)
                self.occuredLoadingDataError()
            }
        }
        netApiFacade.loadItems(for: .tvshow, searchType: .topRated) { result in
            switch result {
            case .success(let data):
                newSections.append(CinemaItemSection(type: .tvshow, cells: data))
            case .failure(let error):
                DLog(error)
                self.occuredLoadingDataError()
            }
        }
        return newSections
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(TVShowCollectionViewCell.self, forCellWithReuseIdentifier: TVShowCollectionViewCell.identifier)
        collectionView.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier)
        
        collectionView.backgroundColor = .mainAppColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
    private func setupIconLabel() {
        view.addSubview(iconLabel)
        let string = NSMutableAttributedString(string: .appIconTittleFull)
        string.setColorForText(.appIconTittleFirst, with: .prettyWhite)
        string.setColorForText(.appIconTittleSecond, with: .redIconColor)
        iconLabel.font = .iconFont
        iconLabel.attributedText = string
    }
    
    private func setupUI() {
        view.backgroundColor = .mainAppColor
        
        guard let collectionView = collectionView else {
            fatalError()
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            iconLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            iconLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: .smallPadding),
            
            collectionView.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: .iconPadding),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Collection View Delegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        switch model.type {
        case .movie:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCollectionViewCell.identifier,
                for: indexPath) as? MovieCollectionViewCell, let movie = model as? Movie
            else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: movie)
            return cell
        case .tvshow:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TVShowCollectionViewCell.identifier,
                for: indexPath) as? TVShowCollectionViewCell, let tvshow = model as? TVShow
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: tvshow)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = sections[indexPath.section].cells[indexPath.row]
        showDetails(for: model)
    }
    
    private func showDetails(for item: CinemaItemProtocol) {
        DispatchQueue.main.async {
            let vc = DetailsViewController()
            vc.currentCinemaItem = item
            let backButton = UIBarButtonItem()
            backButton.title = .none
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type

        switch sectionType {

        case .movie:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: .smallPadding,
                                                         leading: .smallPadding,
                                                         bottom: .smallPadding,
                                                         trailing: .smallPadding
            )
            
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(50)
            )
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            let movieRowWidth = view.frame.size.width/2.3
            let movieRowHeight = movieRowWidth*2
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .estimated(movieRowWidth),
                    heightDimension: .estimated(movieRowHeight)),
                subitems: [item])

            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            sectionLayout.boundarySupplementaryItems = [headerItem]

            return sectionLayout

        case .tvshow:
            let tvshowRowWidth = view.frame.size.width/2.8
            let tvshowRowHeight = tvshowRowWidth*2
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: .smallPadding,
                                                         leading: .smallPadding,
                                                         bottom: .smallPadding,
                                                         trailing: .smallPadding
            )
            
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(50)
            )
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(tvshowRowWidth),
                    heightDimension: .absolute(tvshowRowHeight)),
                subitems: [item])
    
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            sectionLayout.boundarySupplementaryItems = [headerItem]
            return sectionLayout
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = sections[indexPath.section].type
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeader.identifier, for: indexPath) as? CollectionHeader else {
            return UICollectionReusableView()
        }
        switch sectionType {
            
        case .movie:
            header.configure(with: sectionType.title)
        case .tvshow:
            header.configure(with: sectionType.title)
        }
        return header
    }
}


