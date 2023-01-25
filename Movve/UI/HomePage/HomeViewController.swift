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
        refreshSections() { success in
            if success {
                self.handleSuccessRefreshingData()
            } else {
                self.handleLoadingDataError()
            }
        }
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
    
    
    private func setupConstraints() {
        guard let collectionView = collectionView else {
            fatalError()
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            iconLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: .smallPadding),
            
            collectionView.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: .iconPadding),
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? AnimaCell else { return }
        let layer = createCellLayer(with: cell)
        hideUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let model = self.sections[indexPath.section].cells[indexPath.row]
            self.pushDetailsVC(for: model, with: .custom)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            layer.removeFromSuperlayer()
            self.showUI()
        }
    }
    
    private func pushDetailsVC(for item: CinemaItemProtocol, with transitionType: TransitionType) {
        DispatchQueue.main.async {
            let vc = DetailsViewController()
            vc.currentCinemaItem = item
            let backButton = UIBarButtonItem()
            backButton.title = .none
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.setTransitionType(transitionType: transitionType)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func createCellLayer(with cell: AnimaCell) -> CALayer {
        let layer = CALayer()
        layer.frame = self.view?.layer.convert(cell.layer.frame, from: cell.superview?.layer) ?? .zero
        layer.contents = cell.snapshotView(afterScreenUpdates: false)?.layer.contents
        layer.cornerRadius = .cornerRadius
        
        self.view.layer.addSublayer(layer)
        
        ///ANIMATIONS
        var animations = [CABasicAnimation]()
        let moveAnim = CABasicAnimation(keyPath: "position")
        moveAnim.toValue = NSValue(cgPoint: CGPoint(x: self.view.frame.midX,
                                                    y: self.view.frame.midY)
        )
        moveAnim.duration = 1
        animations.append(moveAnim)

        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = [1,1]
        scaleAnim.toValue = [self.view.frame.size.width / layer.frame.size.width * 0.8, self.view.frame.size.height / layer.frame.size.height * 0.8]
        scaleAnim.duration = 1
        animations.append(scaleAnim)

        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.toValue = 0.5
        fadeAnim.duration = 1
        animations.append(fadeAnim)
        
        let group = CAAnimationGroup()
        group.duration = 1
        group.animations = animations
        layer.add(group, forKey: nil)
        return layer
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
