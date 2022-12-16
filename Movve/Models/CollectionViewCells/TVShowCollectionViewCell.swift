//
//  TVShowCollectionViewCell.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class TVShowCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TVShowCollectionViewCell"
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let captionLabel: UILabel = {
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
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(captionLabel)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .lightGray
    }
    
    private func setupSubViews() {
        thumbnailImageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        captionLabel.frame = CGRect(x: 0, y: 20, width: 150, height: 100)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        captionLabel.text = nil
    }
    
    func configure(with viewModel: TVShow) {
        if let image = viewModel.posterImage {
            thumbnailImageView.image = image
        } else {
            thumbnailImageView.image = UIImage(systemName: "xmark")
        }
        captionLabel.text = viewModel.name
    }
}

