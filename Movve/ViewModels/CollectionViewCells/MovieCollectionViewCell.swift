//
//  MovieCollectionViewCell.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView = UIImageView()
    private let movieTitleLabel = UILabel ()
    private let dateReleaseLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        contentView.clipsToBounds = true
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(dateReleaseLabel)
        contentView.layer.masksToBounds = true
    }
    
    private func setupSubViews() {
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = .cornerRadius
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        movieTitleLabel.numberOfLines = 0
        movieTitleLabel.textColor = .prettyWhite
        movieTitleLabel.font = .cellTitleFont
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateReleaseLabel.numberOfLines = 0
        dateReleaseLabel.translatesAutoresizingMaskIntoConstraints = false
        dateReleaseLabel.textColor = .prettyGray
        dateReleaseLabel.font = .cellDateFont
            
        let constraints = [
            posterImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            posterImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/2),
            
            movieTitleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: .smallPadding),
            movieTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            movieTitleLabel.bottomAnchor.constraint(equalTo: dateReleaseLabel.topAnchor),
            
            dateReleaseLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor),
            dateReleaseLabel.heightAnchor.constraint(equalToConstant: .cellDateHeight),
            dateReleaseLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        movieTitleLabel.text = nil
        dateReleaseLabel.text = nil
    }
    
    func configure(with viewModel: Movie) {
        if let image = viewModel.posterImage {
            posterImageView.image = image
        } else {
            posterImageView.image = .noImage
        }
        
        movieTitleLabel.text = viewModel.title
        dateReleaseLabel.text = DateFormatter.switchDateFormat(from: viewModel.releaseDate)
    }
}

