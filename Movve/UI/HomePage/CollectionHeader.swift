//
//  HomePageCollectionHeader.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class HomePageCollectionHeader: UICollectionReusableView {
    
    static let identifier = "InteractiveHeader"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private func setupLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .headerFont
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -.smallPadding),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: .smallPadding)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with str: String) {
        titleLabel.text = str
        
    }
}
