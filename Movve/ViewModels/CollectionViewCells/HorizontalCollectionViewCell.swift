//
//  HorizontalCollectionViewCell.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 20.12.2022.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HorizontalCollectionViewCell"
    
    private let imageView = UIImageView()
    private let actorNameLabel = UILabel()
    private let characterNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(actorNameLabel)
        contentView.addSubview(characterNameLabel)
        contentView.backgroundColor = .mainAppColor
    }
    
    private func configureViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .imageCornerRadius
        imageView.layer.masksToBounds = true
  
        actorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        actorNameLabel.font = .actorsNameFont
        actorNameLabel.textColor = .prettyWhite
        actorNameLabel.numberOfLines = 0
        actorNameLabel.textAlignment = .center
        
        characterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        characterNameLabel.font = .charactersNameFont
        characterNameLabel.textColor = .prettyGray
        characterNameLabel.numberOfLines = 0
        characterNameLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        let constraints = [
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: .castImageViewHeigt),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            actorNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            actorNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            actorNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            actorNameLabel.heightAnchor.constraint(equalToConstant: .cellDateHeight),

            characterNameLabel.topAnchor.constraint(equalTo: actorNameLabel.bottomAnchor),
            characterNameLabel.widthAnchor.constraint(equalTo: actorNameLabel.widthAnchor),
            characterNameLabel.heightAnchor.constraint(equalToConstant: .cellDateHeight),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        actorNameLabel.text = nil
        characterNameLabel.text = nil
    }
    
    //MARK: - Internal
    func configure(with model: Cast) {
        imageView.image = model.avatar
        actorNameLabel.text = model.name
        characterNameLabel.text = model.character
        
    }
}
