//
//  PresentationController.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 24.01.2023.
//

import UIKit
 
class PresentationController: UIPresentationController {
    
    //Уставновка значения фрейма
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        let quaterHeight = bounds.height / 4
        return CGRect(x: 0, y: bounds.height*3/4, width: bounds.width, height: quaterHeight)
    }
    
    //Иерархия вьюшек вручную
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }
    
    //Отрисовка фреймов
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
