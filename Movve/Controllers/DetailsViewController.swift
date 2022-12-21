//
//  DetailsViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
      
    private var loadingIndicator = UIActivityIndicatorView()
    
    private var iconLabel = UILabel()
    private var dismissButton = UIButton()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        setupUI()
        showLoadingIndicator()
        hideUI()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecivedMovieData), name: NSNotification.Name.successMovieDetailsLoading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecivedTVShowData), name: NSNotification.Name.successTVShowDetailsLoading, object: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .mainAppColor
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        addSubviews()
        setupSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        view.addSubview(iconLabel)
        view.addSubview(dismissButton)
        
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
        
        ///Icon Label
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        let string = NSMutableAttributedString(string: .appIconTitleAddon + " " + .appIconTittleFull)
        string.setColorForText(.appIconTitleAddon, with: .prettyWhite)
        string.setColorForText(.appIconTittleFirst, with: .prettyWhite)
        string.setColorForText(.appIconTittleSecond, with: .redIconColor)
        iconLabel.font = .iconFontItalic
        iconLabel.attributedText = string
        
        //Dismiss Button
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(.dismissImage, for: .normal)
        dismissButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        dismissButton.tintColor = .redIconColor
        
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
        castCollectionView.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: HorizontalCollectionViewCell.identifier)
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
            
            iconLabel.topAnchor.constraint(equalTo: safeG.topAnchor, constant: .smallPadding),
            iconLabel.leftAnchor.constraint(equalTo: safeG.leftAnchor, constant: .smallPadding),
            
            dismissButton.topAnchor.constraint(equalTo: iconLabel.topAnchor),
            dismissButton.rightAnchor.constraint(equalTo: safeG.rightAnchor, constant: -.smallPadding),
            dismissButton.bottomAnchor.constraint(equalTo: iconLabel.bottomAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: .dismissButtonWidth),
            
            scrollView.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: .smallPadding),
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
            ratingView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
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
    
    @objc private func didRecivedMovieData() {
        updateUIWithMovieData()
        hideLoadingIndicator()
        showUI()
    }
    
    private func updateUIWithMovieData() {
        guard let movieOverview = DataManager.shared.giveMovieOverview() else {
            DLog("No data received from DataManager!")
            return
        }
        updateUI(with: movieOverview)
    }
    
    private func updateUI(with model: MovieOverview) {
        ///Image
        if let image = model.details.image {
            imageView.image = image
        } else {
            imageView.image = .noImage
        }
        
        ///Title
        titleLabel.text = model.info.title
        
        ///Info Label ( Year(from Date) * Genre-Genre-Genre * RunTime )
        let dateInfo = model.info.getReleaseDateYear()
        let genres = model.details.getGenres()
        let runtime = model.details.getRuntime()
        infoLabel.text = "\(dateInfo) * \(genres) * \(runtime)"
        
        ///Rating View
        let starsView = StarsView(rating: model.details.rating)
        ratingView.addSubview(starsView)
        starsView.frame = ratingView.bounds
        
        ///Overview
        overviewLabel.text = model.details.overview
        
        ///Cast
        self.cast = model.cast
        castCollectionView.reloadData()
        
        ///Button
        self.watchButtonTarget = model.details.homepage
    }
    
    @objc private func didRecivedTVShowData() {
        updateUIWithTVShowData()
        hideLoadingIndicator()
        showUI()
    }
    
    private func updateUIWithTVShowData() {
        guard let tvshowOverview = DataManager.shared.giveTVShowOverview() else {
            DLog("No data received from DataManager!")
            return
        }
        updateUI(with: tvshowOverview)
    }
    
    private func updateUI(with model: TVShowOverview) {
        ///Image
        if let image = model.details.image {
            imageView.image = image
        } else {
            imageView.image = .noImage
        }
        
        ///Title
        titleLabel.text = model.info.name
        
        ///Info Label ( Date * Genre-Genre-Genre * RunTime )
        let dateInfo = model.info.getReleaseDateYear()
        let genres = model.details.getGenres()
        let seasonCount = model.details.seasons
        infoLabel.text = "\(dateInfo) * \(genres) * \(seasonCount) season(s)"
        
        ///Rating View
        let starsView = StarsView(rating: model.details.rating)
        ratingView.addSubview(starsView)
        starsView.frame = ratingView.bounds
        
        ///Overview
        overviewLabel.text = model.details.overview
        
        ///Cast
        self.cast = model.cast
        castCollectionView.reloadData()
        
        ///Button
        self.watchButtonTarget = model.details.homepage
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
    
    private func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.loadingIndicator.isHidden = false
        }
        
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            
        }
    }
    
    private func showUI() {
        DispatchQueue.main.async {
            self.imageView.isHidden = false
            self.castSectionLabel.isHidden = false
            self.castCollectionView.isHidden = false
            self.titleLabel.isHidden = false
            self.infoLabel.isHidden = false
            self.ratingView.isHidden = false
            self.overviewSectionLabel.isHidden = false
            self.overviewLabel.isHidden = false
            self.watchButton.isHidden = false
        }
    }
    
    private func hideUI() {
        DispatchQueue.main.async {
            self.imageView.isHidden = true
            self.castSectionLabel.isHidden = true
            self.castCollectionView.isHidden = true
            self.titleLabel.isHidden = true
            self.infoLabel.isHidden = true
            self.ratingView.isHidden = true
            self.overviewSectionLabel.isHidden = true
            self.overviewLabel.isHidden = true
            self.watchButton.isHidden = true
        }
    }
    
    //MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.identifier, for: indexPath) as? HorizontalCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: cast[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .castRowSize
    }
}
