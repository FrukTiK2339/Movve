//
//  DetailsViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit
import SafariServices

extension DetailsViewController: NetApiFacadeProviderProtocol {
    var netApiFacade: NetApiFacadeProtocol {
        return NetApiFacade.shared
    }
}

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Public
    var currentCinemaItem: CinemaItemProtocol?
    
    //MARK: - Private
    private var loadingIndicator = UIActivityIndicatorView()
    private var scrollView = UIScrollView()
    
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var infoLabel = UILabel()
    private var ratingView = UIStackView()
    private var overviewSectionLabel = UILabel()
    private var overviewLabel = UILabel()
    
    private var watchButtonTarget = String()
    private var watchButton = UIButton()
    
    private var cast = [Cast]()
    private var castSectionLabel = UILabel()
    private var castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let navigationControllerDelegate = NavigationControllerDelegate()
    private var loadingLayer = CAShapeLayer()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingAnimation()
        setupUI()
        hideUI()
        loadData(for: currentCinemaItem)
    }
    
    private func showLoadingAnimation() {
        let loadAnimator = LoadingAnimator()
        loadingLayer = loadAnimator.createDetailsCALayer(for: self.view)
        view.layer.addSublayer(loadingLayer)
        loadAnimator.addGradientAnimation(for: loadingLayer, for: self.view)
    }
    
    private func setupUI() {
        view.backgroundColor = .mainAppColor
        self.navigationController?.delegate = navigationControllerDelegate
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        addSubviews()
        setupSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(infoLabel)
        scrollView.addSubview(ratingView)
        scrollView.addSubview(overviewSectionLabel)
        scrollView.addSubview(overviewLabel)
        scrollView.addSubview(castSectionLabel)
        scrollView.addSubview(castCollectionView)
        
        view.addSubview(watchButton)
    }
    
    private func setupSubviews() {
        ///Loading indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.style = .large
        
        ///Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        ///Image View
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = .cornerRadius
        
        ///Title Label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .iconFont
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .prettyWhite
        
        ///Info Label
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = .cellTitleFont
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .prettyGray
        
        ///Rating View
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        ///Overview Label + Section Label
        overviewSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewSectionLabel.font = .sectionsItalicFont
        overviewSectionLabel.textAlignment = .left
        overviewSectionLabel.textColor = .prettyWhite
        overviewSectionLabel.text = .overviewSectionTitle
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.font = .cellTitleFont
        overviewLabel.textAlignment = .left
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = .prettyGray
        
        ///Cast Horizontal Collection View
        castSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        castSectionLabel.font = .sectionsItalicFont
        castSectionLabel.textAlignment = .left
        castSectionLabel.textColor = .prettyWhite
        castSectionLabel.text = .castSectionTitle
        
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        castCollectionView.register(CastHorizontalCollectionViewCell.self, forCellWithReuseIdentifier: CastHorizontalCollectionViewCell.identifier)
        castCollectionView.showsHorizontalScrollIndicator = false
        castCollectionView.backgroundColor = .mainAppColor
        
        ///"Watch Now" Button
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        watchButton.backgroundColor = .redIconColor
        watchButton.setTitle(.watchButtonTitle, for: .normal)
        watchButton.layer.cornerRadius = .cornerRadius
        watchButton.addTarget(self, action: #selector(didTapWatchButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        let safeG = view.safeAreaLayoutGuide
        let contentG = scrollView.contentLayoutGuide
        
        let constraints = [
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: safeG.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: safeG.leftAnchor, constant: .smallPadding),
            scrollView.rightAnchor.constraint(equalTo: safeG.rightAnchor, constant: -.smallPadding),
            scrollView.bottomAnchor.constraint(equalTo: watchButton.topAnchor, constant: -.smallPadding),
            
            imageView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: .iconPadding),
            imageView.leftAnchor.constraint(equalTo: safeG.leftAnchor, constant: .smallPadding),
            imageView.rightAnchor.constraint(equalTo: safeG.rightAnchor, constant: -.smallPadding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/2),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .smallPadding),
            titleLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            infoLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            
            ratingView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            ratingView.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/2),
            ratingView.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: .ratingViewHeight),
            
            overviewSectionLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor),
            overviewSectionLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: overviewSectionLabel.bottomAnchor, constant: .smallPadding),
            overviewLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            
            castSectionLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: .smallPadding),
            castSectionLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            
            castCollectionView.topAnchor.constraint(equalTo: castSectionLabel.bottomAnchor, constant: .smallPadding),
            castCollectionView.heightAnchor.constraint(equalToConstant: .castViewHeight),
            castCollectionView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            castCollectionView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -.smallPadding),
            
            watchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchButton.widthAnchor.constraint(equalToConstant: .watchButtonWidth),
            watchButton.heightAnchor.constraint(equalToConstant: .watchButtonHeight),
            watchButton.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -.smallPadding)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    
    private func loadData(for item: CinemaItemProtocol?) {
        guard let cinemaItem = item else {
            fatalError()
        }
        DispatchQueue.global(qos: .background).async {
            self.netApiFacade.loadItemData(for: cinemaItem) { [weak self] result in
                switch result {
                    
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.updateUI(with: data)
                        self?.loadingLayer.removeFromSuperlayer()
                        self?.showUI()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func updateUI(with itemData: CinemaItemDataProtocol) {
        ///Image
        if let image = itemData.details.image {
            imageView.image = image
        } else {
            imageView.image = .noImage
        }
        
        ///Title
        titleLabel.text = itemData.item.title
        
        
        ///Info Label
        updateLabelInfo(with: itemData)
        
        ///Rating View
        let ratingLabel = UILabel()
        ratingLabel.text = String(format: "%.1f", itemData.details.rating)
        ratingLabel.textColor = .systemYellow
        ratingView.addArrangedSubview(ratingLabel)
        ratingView.axis = .horizontal
        ratingView.alignment = .center
        ratingView.distribution = .fillEqually
        ratingView.spacing = .smallPadding
        let starsCount = Int(itemData.details.rating / 1.5)
        for _  in 1...starsCount {
            let star = UIImageView(image: .starImage)
            star.tintColor = .systemYellow
            ratingView.addArrangedSubview(star)
        }
        if starsCount < 5 {
            for _ in 1...5 - starsCount {
                let emptyStar = UIImageView(image: .starImage)
                emptyStar.tintColor = .prettyGray
                ratingView.addArrangedSubview(emptyStar)
            }
        }
        
        ///Overview
        overviewLabel.text = itemData.details.overview
        
        ///Cast
        self.cast = itemData.cast
        castCollectionView.reloadData()
        
        ///Button
        if itemData.details.homepage.isEmpty {
            watchButton.isEnabled = false
            watchButton.alpha = 0.5
        } else {
            self.watchButtonTarget = itemData.details.homepage
            watchButton.isEnabled = true
        }
        
    }
    
    private func updateLabelInfo(with itemData: CinemaItemDataProtocol) {
        switch itemData.item.type {
            
        case .movie:
            guard let movieDetails = itemData.details as? MovieDetails else {
                return
            }
            let dateInfo = itemData.item.getReleaseDateYear()
            let genres = movieDetails.getGenres()
            let runtime = movieDetails.getRuntime()
            infoLabel.text = "\(dateInfo) * \(genres) * \(runtime)"
            
        case .tvshow:
            guard let tvshowDetails = itemData.details as? TVShowDetails else {
                return
            }
            
            let dateInfo = itemData.item.getReleaseDateYear()
            let genres = tvshowDetails.getGenres()
            let seasonCount = tvshowDetails.seasons
            infoLabel.text = "\(dateInfo) * \(genres) * \(seasonCount) season(s)"
        }
    }
    
    @objc private func didTapWatchButton() {
        showSafariVC(urlString: watchButtonTarget)
    }
    
    @objc private func didTapDismiss() {
        self.dismiss(animated: true)
    }
    
    private func showSafariVC(urlString: String) {
        guard let url = URL(string: urlString) else {
            DLog("Incorect homepage data!")
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

    private func showUI() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.imageView.layer.opacity = 1
                self.castSectionLabel.layer.opacity = 1
                self.castCollectionView.layer.opacity = 1
                self.titleLabel.layer.opacity = 1
                self.infoLabel.layer.opacity = 1
                self.ratingView.layer.opacity = 1
                self.overviewSectionLabel.layer.opacity = 1
                self.overviewLabel.layer.opacity = 1
                self.watchButton.layer.opacity = 1
            }
        }
    }
    
    private func hideUI() {
        DispatchQueue.main.async {
            self.imageView.layer.opacity = 0
            self.castSectionLabel.layer.opacity = 0
            self.castCollectionView.layer.opacity = 0
            self.titleLabel.layer.opacity = 0
            self.infoLabel.layer.opacity = 0
            self.ratingView.layer.opacity = 0
            self.overviewSectionLabel.layer.opacity = 0
            self.overviewLabel.layer.opacity = 0
            self.watchButton.layer.opacity = 0
        }
    }
    
    //MARK: - Collection View Delegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastHorizontalCollectionViewCell.identifier, for: indexPath) as? CastHorizontalCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: cast[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .castRowSize
    }
}