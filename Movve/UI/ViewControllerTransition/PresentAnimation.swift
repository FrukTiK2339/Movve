//
//  PresentAnimation.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 24.01.2023.
//

import UIKit

extension PresentAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }
    
    //Это для прерывания анимации, если не указывать, то тогда надо вручную вызвать анимацию у PropertyAnimator
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}



class PresentAnimation: NSObject {
    //Все для протокола
    
    //Длительность анимации
    let duration: TimeInterval = 0.7
    
    //создание UIViewImplicitlyAnimating, что это??
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let to = transitionContext.view(forKey: .to)!
        
        // Фрейм из PresentationController
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        
        // Смещение  за границу экрана
        to.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            // Возвращаем на место, так он выезжает снизу
            to.frame = finalFrame
        }
        
        animator.addCompletion { (position) in
            // Завершаем переход, если он не был отменён
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        return animator
    }
    
}
