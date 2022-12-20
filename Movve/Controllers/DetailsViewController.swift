//
//  DetailsViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let dateFormatter = DateFormatter()
    
    public var movie: Movie?
    
    private var loadingIndicator = UIActivityIndicatorView()
    
    private var iconLabel = UILabel()
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var infoLabel = UILabel()
    private var ratingView = UIView()
    private var overviewLabel = UILabel()
//    private var castCollectionView = UICollectionView()
    private var watchButton = UIButton()
    
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
        addSubviews()
        setupSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(loadingIndicator)
        
        view.addSubview(iconLabel)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(infoLabel)
        view.addSubview(ratingView)
        view.addSubview(overviewLabel)
        //        view.addSubview(castCollectionView)
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
        iconLabel.font = UIFont(name: "Trebuchet-BoldItalic", size: 32)
        iconLabel.attributedText = string
        
        
        ///Image View
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        
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
        ratingView.backgroundColor = .prettyGray
        
        ///Overview Label
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.font = .cellTitleFont
        overviewLabel.textAlignment = .left
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = .prettyGray
        
        ///Cast Horizontal Collection View
//        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        ///"Watch Now" Button
        watchButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        let constraints = [
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            iconLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .smallPadding),
            iconLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: .smallPadding),
            
            imageView.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: .iconPadding),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .smallPadding),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.smallPadding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/2),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .smallPadding),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
//            infoLabel.heightAnchor.constraint(equalToConstant: .cellDateHeight),
            infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: ratingView.topAnchor),
            
            ratingView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            ratingView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: .cellTitleHeight),
            
            overviewLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor),
            overviewLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            overviewLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor),
            
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
        let starsView = StarsView(rating: model.details.rating, frame: .zero)
        ratingView.addSubview(starsView)
        starsView.frame = ratingView.bounds
        
        ///Overview
        overviewLabel.text = model.details.overview
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
        
        
        ///Overview
        overviewLabel.text = model.details.overview
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
//            self.castCollectionView.isHidden = false
            self.titleLabel.isHidden = false
            self.infoLabel.isHidden = false
            self.ratingView.isHidden = false
            self.overviewLabel.isHidden = false
            self.watchButton.isHidden = false
        }
    }
    
    private func hideUI() {
        DispatchQueue.main.async {
            self.imageView.isHidden = true
//            self.castCollectionView.isHidden = true
            self.titleLabel.isHidden = true
            self.infoLabel.isHidden = true
            self.ratingView.isHidden = true
            self.overviewLabel.isHidden = true
            self.watchButton.isHidden = true
        }
    }
    
}
