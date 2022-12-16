//
//  MovieCollectionViewCell.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let dateReleaseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
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
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .gray
    }
    
    private func setupSubViews() {
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = MovieCollectionViewCell.cornerRadius
        
        

        
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
            posterImageView.image = UIImage(systemName: "xmark")
        }
        
        movieTitleLabel.text = viewModel.title
        dateReleaseLabel.text = viewModel.releaseDate
    }
}

