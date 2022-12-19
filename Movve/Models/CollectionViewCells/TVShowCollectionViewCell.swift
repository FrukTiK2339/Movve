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
    private let tvShowTitleLabel = UILabel ()
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
        contentView.addSubview(tvShowTitleLabel)
        contentView.addSubview(dateReleaseLabel)
        contentView.layer.masksToBounds = true
    }
    
    private func setupSubViews() {
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = .cornerRadius
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        tvShowTitleLabel.numberOfLines = 0
        tvShowTitleLabel.textColor = .prettyWhite
        tvShowTitleLabel.font = .cellTitleFont
        tvShowTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateReleaseLabel.numberOfLines = 0
        dateReleaseLabel.translatesAutoresizingMaskIntoConstraints = false
        dateReleaseLabel.textColor = .prettyGray
        dateReleaseLabel.font = .cellDateFont
        
        let posterHeight: CGFloat = contentView.frame.width*3/2
        
        let constraints = [
            posterImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            
            tvShowTitleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: .smallPadding),
            tvShowTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            tvShowTitleLabel.bottomAnchor.constraint(equalTo: dateReleaseLabel.topAnchor),
            
            dateReleaseLabel.topAnchor.constraint(equalTo: tvShowTitleLabel.bottomAnchor),
            dateReleaseLabel.heightAnchor.constraint(equalToConstant: .cellDateHeight),
            dateReleaseLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        tvShowTitleLabel.text = nil
        dateReleaseLabel.text = nil
    }
    
    func configure(with viewModel: TVShow) {
        if let image = viewModel.posterImage {
            posterImageView.image = image
        } else {
            posterImageView.image = .noImage
        }
        
        tvShowTitleLabel.text = viewModel.name
        dateReleaseLabel.text = dateFormatter.switchDateFormat(from: viewModel.releaseDate)
    }
}

