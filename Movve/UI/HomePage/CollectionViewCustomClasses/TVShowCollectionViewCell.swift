//
//  TVShowCollectionViewCell.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

protocol AnimaCell: UICollectionViewCell {
    var titleLabel: UILabel { get }
    var imageView: UIImageView { get }
    var dateLabel: UILabel { get }
}

class TVShowCollectionViewCell: UICollectionViewCell, AnimaCell {
    
    static let identifier = "TVShowCollectionViewCell"
    
    var imageView = UIImageView()
    var titleLabel = UILabel ()
    var dateLabel = UILabel()
    
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
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.layer.masksToBounds = true
    }
    
    private func setupSubViews() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = .cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .prettyWhite
        titleLabel.font = .cellTitleFont
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.numberOfLines = 0
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .prettyGray
        dateLabel.font = .cellDateFont
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/2),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .smallPadding),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: .cellDateHeight),
            dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    func configure(with viewModel: TVShow) {
        if let image = viewModel.posterImage {
            imageView.image = image
        } else {
            imageView.image = .noImage
        }
        
        titleLabel.text = viewModel.title
        dateLabel.text = DateFormatter.switchDateFormat(from: viewModel.releaseDate)
    }
}

