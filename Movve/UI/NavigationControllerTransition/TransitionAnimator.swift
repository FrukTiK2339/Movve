//
//  TransitionAnimator.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 24.01.2023.
//

import UIKit

enum TransitionType {
    case standard, custom
}

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.7
    private let type: TransitionType
    private let operation: UINavigationController.Operation
    
    init(type: TransitionType, operation: UINavigationController.Operation) {
        self.type = type
        self.operation = operation
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning Functions
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let completion = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        if !transitionContext.isAnimated {
            completion()
            return()
        }
        
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView!)
        
        switch self.operation {
        case .push:
            self.performPushAnimation(toView: toView!, completion: completion)
        case .pop:
            self.performPopAnimation(fromView: fromView!, completion: completion)
        default:
            completion()
            return()
        }
    }
    
    // MARK: - Custom Animation Functions
    
    private func performPushAnimation(toView: UIView, completion: @escaping () -> ()) {
        var frame = toView.frame
        switch self.type {
        case .standard:
            frame.origin.x += frame.size.width
        case .custom:
            toView.alpha = 0
        }
        toView.frame = frame
        
        UIView.animate(withDuration: self.duration, animations: {
            
            switch self.type {
            case .standard:
                frame.origin.x -= frame.size.width
            case .custom:
                toView.alpha = 1
            }
            toView.frame = frame
            
            }) { (finished: Bool) -> Void in
                completion()
        }
    }
    
    private func performPopAnimation(fromView: UIView, completion: @escaping () -> ()) {
        fromView.superview?.bringSubviewToFront(fromView)
        var frame = fromView.frame
        UIView.animate(withDuration: self.duration, animations: {
            
            switch self.type {
            case .standard:
                frame.origin.x += frame.size.width
            case .custom:
                fromView.alpha = 0
            }
            fromView.frame = frame
            
            }) { (finished: Bool) -> Void in
                completion()
        }
    }
    
}
