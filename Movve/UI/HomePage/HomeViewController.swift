//
//  HomeViewController.swift
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

protocol UpdateSectionDataDelegate {
    func refreshSections(completion: @escaping (Bool) -> Void)
    func handleLoadingDataError()
    func handleSuccessLoadingData()
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UpdateSectionDataDelegate {
    
    //MARK: - Private
    private var iconLabel = UILabel()
    private var collectionView: UICollectionView?
    private var sections = [CinemaItemSection]()
    private let dispatchGroup = DispatchGroup()
    private let navigationControllerDelegate = NavigationControllerDelegate()
    private var loadingLayer = CAShapeLayer()
    private let transition = PopUpPanelTransition()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.delegate = navigationControllerDelegate
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainAppColor
        self.navigationController?.delegate = self.navigationControllerDelegate
        
        addObservers()
        setupIconLabel()
        setupCollectionView()
        setupConstraints()
        showLoadingAnimation()
        hideUI()
        updateData()
    }
    
    private func updateData() {
        refreshSections() { [self] success in
            if success {
                self.handleSuccessLoadingData()
            } else {
                self.handleLoadingDataError()
            }
        }
    }
    
    private func showLoadingAnimation() {
            self.loadingLayer.removeFromSuperlayer()
            let loadAnimator = LoadingAnimator()
            loadingLayer = loadAnimator.createHomeCALayer(for: self.view)
            view.layer.insertSublayer(loadingLayer, above: collectionView?.layer)
            loadAnimator.addGradientAnimation(for: loadingLayer, for: self.view)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoadingDataError), name: Notification.Name.errorLoadingData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAlertDismissed), name: Notification.Name.alertDismissed, object: nil)
    }
    
    
    func handleSuccessLoadingData() {
        DispatchQueue.main.async {
            let indexSet = IndexSet(self.sections.indices)
            self.collectionView?.insertSections(indexSet)
            self.loadingLayer.removeFromSuperlayer()
            self.showUI()
        }
    }
    
    @objc private func handleEnterForeground() {
        showLoadingAnimation()
        hideUI()
        updateData()
    }
    
    @objc func handleLoadingDataError() {
        DispatchQueue.main.async {
            self.showLoadingAnimation()
            let popUpVC = CommonPopUpViewController()
            popUpVC.delegate = self
            popUpVC.transitioningDelegate = self.transition
            popUpVC.modalPresentationStyle = .custom
            self.present(popUpVC, animated: true)
        }
    }
    
    @objc func handleAlertDismissed() {
        updateData()
    }
    
    private func handleSuccessRefreshingData() {
        DispatchQueue.main.async {
            let indexSet = IndexSet(self.sections.indices)
            self.collectionView?.reloadSections(indexSet)
            self.loadingLayer.removeFromSuperlayer()
            self.showUI()
        }
    }
    
    private func hideUI() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.collectionView?.layer.opacity = 0
            }
        }
    }
    
    private func showUI() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.collectionView?.layer.opacity = 1
            }
        }
    }
    
    func refreshSections(completion: @escaping (Bool) -> Void) {
         sections = [CinemaItemSection]()
         DispatchQueue.global(qos: .background).async {
            var badData = 0
            self.dispatchGroup.enter()
            self.netApiFacade.loadItems(for: .movie, searchType: .popular) { result in
                switch result {
                case .success(let data):
                    self.sections.append(CinemaItemSection(type: .movie, cells: data))
                case .failure(let error):
                    DLog(error)
                    badData += 1
                }
                self.dispatchGroup.leave()
            }
            self.dispatchGroup.enter()
            self.netApiFacade.loadItems(for: .tvshow, searchType: .topRated) { result in
                switch result {
                case .success(let data):
                    self.sections.append(CinemaItemSection(type: .tvshow, cells: data))
                case .failure(let error):
                    DLog(error)
                    badData += 1
                }
                self.dispatchGroup.leave()
            }
            self.dispatchGroup.wait()
            if badData > 0 {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        
        collectionView.register(HomePageCollectionViewCell.self, forCellWithReuseIdentifier: HomePageCollectionViewCell.identifier)
        collectionView.register(HomePageCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomePageCollectionHeader.identifier)
        
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
    
    
    private func setupConstraints() {
        guard let collectionView = collectionView else {
            fatalError()
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            iconLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: .smallPadding),
            
            collectionView.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: .normalPadding),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - Collection View Delegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].cells[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageCollectionViewCell.identifier, for: indexPath) as? HomePageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: item)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomePageCollectionViewCell else { return }
        
        let item = sections[indexPath.section].cells[indexPath.row]
        let vc = DetailsViewController()
        vc.currentCinemaItem = item
        vc.cinemaTitle = cell.titleLabel.text
        vc.titleFrame = self.view?.layer.convert(cell.titleLabel.layer.frame, from: cell.titleLabel.superview?.layer) ?? .zero
        
        push(vc: vc, transitionType: .custom)
    }
    
    private func push(vc: UIViewController, transitionType: TransitionType) {
            let backButton = UIBarButtonItem()
            backButton.title = .none
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.setTransitionType(transitionType: transitionType)
            self.navigationController?.pushViewController(vc, animated: true)
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
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomePageCollectionHeader.identifier, for: indexPath) as? HomePageCollectionHeader else {
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
