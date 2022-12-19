//
//  DetailsViewController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let dateFormatter = DateFormatter()
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(didRecivedMovieData), name: NSNotification.Name.successMovieDetailsLoading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecivedTVShowData), name: NSNotification.Name.successTVShowDetailsLoading, object: nil)
        hideUI()
        setupUI()
        view.backgroundColor = .mainAppColor
    }
    
    private func setupUI() {
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
        
        ///Icon Label
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
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
            
            iconLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            iconLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: .smallPadding),
            
            imageView.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: .iconPadding),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .smallPadding),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.smallPadding),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .smallPadding),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: .cellDateHeight),
            infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            
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
//        hideLoadingIndicator()
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
//        guard let receivedDetails = DataManager.shared.giveDetailsData() else {
//            DLog("No data received from DataManager!")
//            return
//        }
//        updateUI(with: receivedDetails)
    }
    
    
    
    private func updateUI(with model: MovieOverview) {
        ///Image
        if let image = model.details.detailsImage {
            imageView.image = image
        } else {
            imageView.image = .noImage
        }
        
        ///Title
        titleLabel.text = model.movieInfo.title
        
        ///Info Label ( Date * Genre-Genre-Genre * RunTime )
        let dateInfo = dateFormatter.showOnlyYear(from: model.movieInfo.releaseDate)
        let genres = getGenres(from: model.details)
        let runtime = getRuntime(from: model.details)
        infoLabel.text = "\(dateInfo) * \(genres) * \(runtime)"
        
        ///Rating View
        
        
        ///Overview
        overviewLabel.text = model.details.overview
    }
    
    private func updateUI(with overviewModel: TVShowOverview) {
        if let image = overviewModel.details.detailsImage {
            imageView.image = image
        } else {
            imageView.image = .noImage
        }
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
    
    private func getGenres(from details: Details) -> String {
        var result = String()
        for genre in details.genres {
            result += "\(genre.name), "
        }
        return String(result.dropLast(2))
    }
    
    private func getRuntime(from details: Details) -> String {
        return "\(details.runtime / 60) h \((details.runtime % 60)) min"
    }
    
    private func setupIconLabel() {
        view.addSubview(iconLabel)
        let string = NSMutableAttributedString(string: .appIconTittleFull)
        string.setColorForText(.appIconTittleFirst, with: .prettyWhite)
        string.setColorForText(.appIconTittleSecond, with: .redIconColor)
        iconLabel.font = .iconFont
        iconLabel.attributedText = string
    }
}
