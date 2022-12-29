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
    
    init(rating: Double) {
        self.rating = rating
        super.init(frame: .zero)
        configureViews()
    }
    let ratingLabel = UILabel()
    
    func configureViews() {
        ///Rating Label
        self.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.text = String(format: "%.1f", rating)
        ratingLabel.textColor = .systemYellow
       
        ///Rating Stars
        let starsCount = Int(rating / 1.5)
        var lastPosition = ratingLabel.rightAnchor
        var starWidth: CGFloat = 0
        
        ///Normal Star
        for _  in 1...starsCount {
            let star = UIImageView(image: .starImage)
            star.tintColor = .systemYellow
            starWidth = star.frame.size.width
            self.addSubview(star)
            star.translatesAutoresizingMaskIntoConstraints = false
            star.leftAnchor.constraint(equalTo: lastPosition, constant: .smallPadding).isActive = true
            star.topAnchor.constraint(equalTo: ratingLabel.topAnchor).isActive = true
            lastPosition = star.rightAnchor
        }
        ///Empty Star
        if starsCount < 5 {
            for _ in 1...5 - starsCount {
                let emptyStar = UIImageView(image: .starImage)
                emptyStar.tintColor = .prettyGray
                starWidth = emptyStar.frame.size.width
                self.addSubview(emptyStar)
                emptyStar.translatesAutoresizingMaskIntoConstraints = false
                emptyStar.leftAnchor.constraint(equalTo: lastPosition, constant: .smallPadding).isActive = true
                emptyStar.topAnchor.constraint(equalTo: ratingLabel.topAnchor).isActive = true
                lastPosition = emptyStar.rightAnchor
            }
        }
        let padding: CGFloat = .smallPadding*2.5 + starWidth*3
        let constraints = [
            ratingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ratingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -padding)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

