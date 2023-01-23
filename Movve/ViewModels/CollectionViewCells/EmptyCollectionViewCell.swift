//
//  EmptyCollectionViewCell.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 20.01.2023.
//

import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {
    static let identifier = "EmptyCollectionViewCell"
    
    private let darkImageView = UIImageView()
    private let darkTitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        contentView.addSubview(darkImageView)
        contentView.addSubview(darkTitleLabel)
    }
    
    private func setupSubViews() {
        darkImageView.layer.cornerRadius = .cornerRadius
        darkImageView.clipsToBounds = true
        darkImageView.translatesAutoresizingMaskIntoConstraints = false
        darkImageView.backgroundColor = .emptySpace
        
        darkTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        darkTitleLabel.clipsToBounds = true
        darkTitleLabel.backgroundColor = .emptySpace
        darkTitleLabel.layer.cornerRadius = .cornerRadius
        
        let constraints = [
            darkImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            darkImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            darkImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/2),
        
            darkTitleLabel.topAnchor.constraint(equalTo: darkImageView.bottomAnchor, constant: .iconPadding),
            darkTitleLabel.heightAnchor.constraint(equalToConstant: .cellTitleHeight),
            darkTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        darkImageView.image = nil
        darkTitleLabel.text = nil
    }
}


