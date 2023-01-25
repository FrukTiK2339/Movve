//
//  LoadingAnimator.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 24.01.2023.
//

import UIKit

class LoadingAnimator {
    
    let color: UIColor = .emptySpace
//    UIColor(red: 0.341, green: 0.325, blue: 0.365, alpha: 1.000)
    let myLayer = CAShapeLayer()
    var bezierPaths = [UIBezierPath]()
    
    private func createStroke(line: UIBezierPath) {
        myLayer.path = line.cgPath
        myLayer.strokeColor = color.cgColor
        myLayer.fillColor = color.cgColor
        myLayer.lineWidth = 1
    }
    
    func createDetailsCALayer(for view: UIView) -> CAShapeLayer {
        setupDetailsBezierPaths(from: view)
        let endPath = UIBezierPath()
        for path in bezierPaths {
            endPath.append(path)
        }
        createStroke(line: endPath)
        return myLayer
        
    }
    
    func createHomeCALayer(for view: UIView) -> CAShapeLayer {
        setupHomeBezierPaths(from: view)
        let endPath = UIBezierPath()
        for path in bezierPaths {
            endPath.append(path)
        }
        createStroke(line: endPath)
        return myLayer
    }
    
    private func setupDetailsBezierPaths(from view: UIView) {
        let size: CGFloat = 24
        let yPadding = view.frame.height/6
        let dWidth = view.frame.width - size*2
        let dHeight = dWidth*2/3
        let opalSize = (view.frame.width - size*5)/4
        bezierPaths = [
            UIBezierPath(roundedRect: CGRect(x: size, y: yPadding, width: dWidth, height: dHeight), cornerRadius: 4),
         UIBezierPath(roundedRect: CGRect(x: size, y: yPadding + size + dHeight, width: dWidth, height: .ratingViewHeight), cornerRadius: 4),
         UIBezierPath(roundedRect: CGRect(x: size, y: yPadding + size*2 + dHeight + .ratingViewHeight, width: dWidth, height: .ratingViewHeight), cornerRadius: 4),
         UIBezierPath(roundedRect: CGRect(x: size, y: yPadding + size*3 + dHeight + .ratingViewHeight*2, width: dWidth, height: .ratingViewHeight), cornerRadius: 4),
         
         UIBezierPath(ovalIn: CGRect(x: size, y: yPadding + size*4 + dHeight + .ratingViewHeight*4, width: opalSize, height: opalSize)),
         UIBezierPath(ovalIn: CGRect(x: size*2 + opalSize, y: yPadding + size*4 + dHeight + .ratingViewHeight*4, width: opalSize, height: opalSize)),
         UIBezierPath(ovalIn: CGRect(x: size*3 + opalSize*2, y: yPadding + size*4 + dHeight + .ratingViewHeight*4, width: opalSize, height: opalSize)),
         UIBezierPath(ovalIn: CGRect(x: size*4 + opalSize*3, y: yPadding + size*4 + dHeight + .ratingViewHeight*4, width: opalSize, height: opalSize))
        ]
    }
    
    private func setupHomeBezierPaths(from view: UIView) {
        let spacePadding: CGFloat = 8
        let sectionPadding: CGFloat = 88
        let yPadding: CGFloat = 190
        
        let movieWidth = view.frame.width/2.3
        let movieHeight = movieWidth/2*2.7
        
        let tvshowWidth = view.frame.width/2.8
        let tvshowHeight = tvshowWidth/2*2.7
        bezierPaths = [
            ///Movie image
            UIBezierPath(roundedRect: CGRect(x: spacePadding, y: yPadding, width: movieWidth, height: movieHeight), cornerRadius: 4),
            UIBezierPath(roundedRect: CGRect(x: spacePadding*2 + movieWidth, y: yPadding, width: movieWidth, height: movieHeight), cornerRadius: 4),
            UIBezierPath(roundedRect: CGRect(x: spacePadding*3 + movieWidth*2, y: yPadding, width: movieWidth, height: movieHeight), cornerRadius: 4),
            ///Movie title
            UIBezierPath(roundedRect: CGRect(x: spacePadding, y: yPadding  + movieHeight + spacePadding, width: movieWidth, height: .ratingViewHeight), cornerRadius: 4),
            UIBezierPath(roundedRect: CGRect(x: spacePadding*2 + movieWidth, y: yPadding  + movieHeight + spacePadding, width: movieWidth, height: .ratingViewHeight), cornerRadius: 4),
            UIBezierPath(roundedRect: CGRect(x: spacePadding*3 + movieWidth*2, y: yPadding  + movieHeight + spacePadding, width: movieWidth, height: .ratingViewHeight), cornerRadius: 4),
            
          
            ///TVShow image
            UIBezierPath(roundedRect: CGRect(x: spacePadding, y: yPadding  + movieHeight + spacePadding + .ratingViewHeight + sectionPadding , width: tvshowWidth, height: tvshowHeight), cornerRadius: 4),
            UIBezierPath(roundedRect: CGRect(x: spacePadding*2 + tvshowWidth, y: yPadding  + movieHeight + spacePadding + .ratingViewHeight + sectionPadding , width: tvshowWidth, height: tvshowHeight), cornerRadius: 4),
            UIBezierPath(roundedRect: CGRect(x: spacePadding*3 + tvshowWidth*2, y: yPadding  + movieHeight + spacePadding + .ratingViewHeight + sectionPadding , width: tvshowWidth, height: tvshowHeight), cornerRadius: 4),
            //TVShow title
            UIBezierPath(roundedRect: CGRect(x: spacePadding, y: yPadding  + movieHeight + spacePadding*2 + .ratingViewHeight + sectionPadding + tvshowHeight, width: tvshowWidth, height: .ratingViewHeight), cornerRadius: 4),
            UIBezierPath(roundedRect: CGRect(x: spacePadding*2 + tvshowWidth, y: yPadding  + movieHeight + spacePadding*2 + .ratingViewHeight + sectionPadding + tvshowHeight, width: tvshowWidth, height: .ratingViewHeight), cornerRadius: 4),
            UIBezierPath(roundedRect: CGRect(x: spacePadding*3 + tvshowWidth*2, y: yPadding  + movieHeight + spacePadding*2 + .ratingViewHeight + sectionPadding + tvshowHeight, width: tvshowWidth, height: .ratingViewHeight), cornerRadius: 4),
            
            
        ]
    }
    
    func addGradientAnimation(for layer: CAShapeLayer, for view: UIView) {
        let angle = -60 * CGFloat.pi / 180
        //Gradient Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width*5, height: view.frame.height*2/3)
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        layer.mask = gradientLayer
        
        //Animation
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.5
        animation.fromValue = -view.frame.width*4
        animation.toValue = view.frame.width/3
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "")
    }
    
}
