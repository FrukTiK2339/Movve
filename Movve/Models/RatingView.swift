//
//  RatingView.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 20.12.2022.
//

import UIKit

class StarsView: UIStackView {
    var rating: Double
    
    override init(frame: CGRect) {
        self.rating = 0
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rating: Double, frame: CGRect) {
        self.rating = rating
        super.init(frame: frame)
        configureViews()
    }
    
    
    let ratingLabel = UILabel()
    
    func configureViews() {
        contentMode = .center
        
        self.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.text = "\(rating)"
        
        let starsCount = Int(rating / 1.5)
        var lastPosition = ratingLabel.rightAnchor
        for _  in 1...starsCount {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            self.addSubview(star)
            star.translatesAutoresizingMaskIntoConstraints = false
            star.leftAnchor.constraint(equalTo: lastPosition, constant: .smallPadding).isActive = true
            star.topAnchor.constraint(equalTo: ratingLabel.topAnchor).isActive = true
            lastPosition = star.rightAnchor
        }
        if starsCount < 5 {
            for _ in 1...5 - starsCount {
                let emptyStar = UIImageView(image: UIImage(systemName: "star"))
                self.addSubview(emptyStar)
                emptyStar.translatesAutoresizingMaskIntoConstraints = false
                emptyStar.leftAnchor.constraint(equalTo: lastPosition, constant: .smallPadding).isActive = true
                emptyStar.topAnchor.constraint(equalTo: ratingLabel.topAnchor).isActive = true
                lastPosition = emptyStar.rightAnchor
            }
        }
        let constraints = [
            ratingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ratingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
}

