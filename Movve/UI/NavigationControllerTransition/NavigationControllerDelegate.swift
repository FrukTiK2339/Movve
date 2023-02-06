//
//  NavigationControllerDelegate.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 24.01.2023.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    var transitionType: TransitionType = .custom
    
    // MARK: - UINavigationControllerDelegate Functions
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if self.transitionType == .standard {
//            return nil
//        }
        let animator = TransitionAnimator(type: self.transitionType, operation: operation)
        self.transitionType = .custom
        return animator
    }
    
}
