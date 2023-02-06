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
    var cinemaTitle : String?
    var titleFrame = CGRect()
    
    //MARK: - Private
    private var scrollView = UIScrollView()
    
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var infoLabel = UILabel()
    private var ratingView = UIView()
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
    private let fLabel = UILabel()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        showLoadingAnimation()
        hideUI()
        loadData(for: currentCinemaItem)
        startLabelAnimate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        finishLabelAnimate()
    }
    
    private func startLabelAnimate() {
        let fontMultiplierDiv: CGFloat = 32/14 * 1.2
        fLabel.text = cinemaTitle
        fLabel.frame = titleFrame
        fLabel.textAlignment = .left
        fLabel.font = .cellTitleFont
        fLabel.numberOfLines = 0
        fLabel.sizeToFit()
        view.addSubview(fLabel)
        UIView.animate(withDuration: 0.8) {
            self.fLabel.transform = CGAffineTransform(scaleX: fontMultiplierDiv, y: fontMultiplierDiv)
            self.fLabel.layer.position.x = self.view.frame.width/2
            self.fLabel.layer.position.y = self.view.frame.height/2
            self.fLabel.textAlignment = .center
        }
    }
    
    private func finishLabelAnimate() {
        let fontMultiplierDiv: CGFloat = 32/14
        UIView.animate(withDuration: 0.5) {
            self.fLabel.transform = CGAffineTransform(scaleX: fontMultiplierDiv, y: fontMultiplierDiv)
            self.fLabel.frame.origin.y = self.scrollView.frame.origin.y + self.imageView.frame.height + .normalPadding + .smallPadding
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.fLabel.layer.opacity = 0
                self.titleLabel.layer.opacity = 1
            }
        }
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
        view.clipsToBounds = false
        view.addSubview(scrollView)
        
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
        
        ///Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.alwaysBounceVertical = true
        
        ///Image View
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = .cornerRadius
        
        ///Title Label
        titleLabel.text = cinemaTitle
        titleLabel.font = .iconFont
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .prettyWhite
        titleLabel.sizeToFit()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
    
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
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeG.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: safeG.leftAnchor, constant: .smallPadding),
            scrollView.rightAnchor.constraint(equalTo: safeG.rightAnchor, constant: -.smallPadding),
            scrollView.bottomAnchor.constraint(equalTo: watchButton.topAnchor, constant: -.normalPadding),
            
            imageView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: .normalPadding),
            imageView.leftAnchor.constraint(equalTo: safeG.leftAnchor, constant: .smallPadding),
            imageView.rightAnchor.constraint(equalTo: safeG.rightAnchor, constant: -.smallPadding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/2),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .smallPadding),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: titleFrame.width * 32/14),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .smallPadding),
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
            watchButton.widthAnchor.constraint(equalToConstant: .bigButtonWidth),
            watchButton.heightAnchor.constraint(equalToConstant: .bigButtonHeight),
            watchButton.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -.normalPadding)
        ])
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
        
        ///Info Label
        updateLabelInfo(with: itemData)
        
        ///Rating View
        makeStars(for: ratingView, rating: itemData.details.rating)
      
        
        ///Overview
        overviewLabel.text = itemData.details.overview
        
        ///Cast
        self.cast = itemData.cast
        let indexSet = IndexSet(0..<castCollectionView.numberOfSections)
        castCollectionView.reloadSections(indexSet)
        
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
        var time: TimeInterval = 0.4
        DispatchQueue.main.async {
            for view in self.scrollView.subviews {
                if view != self.titleLabel {
                    UIView.animate(withDuration: time) {
                        view.layer.opacity = 1
                    }
                    time += 0.1
                }
            }
            UIView.animate(withDuration: time) {
                self.watchButton.layer.opacity = 1
            }
        }
    }
    
    private func hideUI() {
        DispatchQueue.main.async {
            self.imageView.layer.opacity = 0
            self.castSectionLabel.layer.opacity = 0
            self.titleLabel.layer.opacity = 0
            self.castCollectionView.layer.opacity = 0
            self.infoLabel.layer.opacity = 0
            self.ratingView.layer.opacity = 0
            self.overviewSectionLabel.layer.opacity = 0
            self.overviewLabel.layer.opacity = 0
            self.watchButton.layer.opacity = 0
        }
    }
    
    private func makeStars(for ratingView: UIView, rating: Double) {
        let itemWidth = ratingView.frame.width/6
        let ratingLabel = UILabel()
        
        //Rating Label
        ratingLabel.text = String(format: "%.1f", rating)
        ratingLabel.textColor = .systemYellow
        ratingLabel.textAlignment = .center
        ratingLabel.frame.size = .init(width: itemWidth, height: ratingView.frame.height)
        ratingView.addSubview(ratingLabel)
        
        //Setting Gray Background View
        let grayBGView = UIView()
        grayBGView.frame = CGRect(x: itemWidth, y: 0, width: ratingView.frame.width - itemWidth, height: ratingView.frame.height)
        ratingView.addSubview(grayBGView)
        
        //Setting Yellow Background View
        let yellowBGView = UIView()
        let yellowBGViewWidth = grayBGView.frame.width * (rating / 10)
        yellowBGView.backgroundColor = .systemYellow
        yellowBGView.frame.size = .init(width: yellowBGViewWidth, height: grayBGView.frame.height)
        grayBGView.addSubview(yellowBGView)
        
        //Setting Stars Mask
        let imageLayer = CALayer()
        let image =  UIImage(systemName: "star.fill")!
        imageLayer.contents = image.cgImage
        imageLayer.frame = CGRect(x: 4, y: (grayBGView.frame.height - (grayBGView.frame.width/6 - 4))/2 , width: grayBGView.frame.width/6 - 4, height: grayBGView.frame.width/6 - 4)
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = 5
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(grayBGView.frame.width/6 + 4 , 0, 0)
        replicatorLayer.addSublayer(imageLayer)
        
        grayBGView.layer.addSublayer(replicatorLayer)
        grayBGView.layer.mask = replicatorLayer
        grayBGView.backgroundColor = .prettyGray
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
