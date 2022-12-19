//
//  TVShowCollectionViewCell.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class TVShowCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TVShowCollectionViewCell"
    
    private let dateFormatter = DateFormatter()
    
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
        movieTitleLabel.textColor = .white
        movieTitleLabel.font = .movieTitleFont
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateReleaseLabel.numberOfLines = 0
        dateReleaseLabel.translatesAutoresizingMaskIntoConstraints = false
        dateReleaseLabel.textColor = .gray
        dateReleaseLabel.font = .movieReleaseDateFont
        
        let posterHeight: CGFloat = contentView.frame.width*3/2
        
        let constraints = [
            posterImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            
            movieTitleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: .smallPadding),
            movieTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            movieTitleLabel.bottomAnchor.constraint(equalTo: dateReleaseLabel.topAnchor),
            
            dateReleaseLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor),
            dateReleaseLabel.heightAnchor.constraint(equalToConstant: MovieCollectionViewCell.dateLabelHeight),
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
    
    func configure(with viewModel: TVShow) {
        if let image = viewModel.posterImage {
            posterImageView.image = image
        } else {
            posterImageView.image = .noImage
        }
        
        movieTitleLabel.text = viewModel.name
        dateReleaseLabel.text = dateFormatter.switchDateFormat(from: viewModel.releaseDate)
    }
}

