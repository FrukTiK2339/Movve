//
//  ViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var iconLabel = UILabel()
    private var collectionView: UICollectionView?
    private var sections = [TargetSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        configureModels()
        setupCollectionView()
        setupIconLabel()
        setupUI()
    }
    
    private func configureModels() {
        ///Movies(popular) section
        sections.append(
            TargetSection(
                type: .movies,
                cells: dataManager.movieArray.compactMap({
                    return TargetCell.movie(viewModel: $0)
                })
            )
        )
        ///TV Show(top rated) section
        sections.append(
            TargetSection(
                type: .tvshows,
                cells: dataManager.tvshowArray.compactMap({
                    return TargetCell.tvshow(viewModel: $0)
                })
            )
        )
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
        switch model {
        case .movie(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCollectionViewCell.identifier,
                for: indexPath) as? MovieCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell
        case .tvshow(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TVShowCollectionViewCell.identifier,
                for: indexPath) as? TVShowCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .movie(let movie):
            DispatchQueue.global(qos: .background).async {
                self.dataManager.getMovieOverview(for: movie)
            }
        case .tvshow(let tvshow):
            DispatchQueue.global(qos: .background).async {
                self.dataManager.getTVShowOverview(for: tvshow)
            }
        }
        DispatchQueue.main.async {
            self.showDetailsVC()
        }
    }
    
    private func showDetailsVC() {
        let vc = DetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type

        switch sectionType {

        case .movies:
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

        case .tvshows:
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
            
        case .movies:
            header.configure(with: sectionType.title)
        case .tvshows:
            header.configure(with: sectionType.title)
        }
        return header
    }
    
}


