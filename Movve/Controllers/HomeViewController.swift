//
//  ViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
    private var collectionView: UICollectionView?
    private var sections = [MovieSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        configureModels()
        setupCollectionView()
        setupUI()
    }
    
    private func configureModels() {
        sections.append(
            MovieSection(
                type: .movies,
                cells: DataManager.shared.giveMovieData(movieType: .movie).compactMap({
                    return MovieCell.movie(viewModel: $0)
                    
                })
            )
        )
        
        sections.append(
            MovieSection(
                type: .tvshows,
                cells: DataManager.shared.giveMovieData(movieType: .tvshow).compactMap({
                    return MovieCell.tvshow(viewModel: $0)
                })
            )
        )
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(TVShowCollectionViewCell.self, forCellWithReuseIdentifier: TVShowCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
    private func setupUI() {
        collectionView?.frame = view.bounds
    }
    
    //MARK: - Collection View Delegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
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
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            return sectionLayout
            
        case .tvshows:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(200)),
                subitems: [item])
            
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            return sectionLayout
        }
    }
}


