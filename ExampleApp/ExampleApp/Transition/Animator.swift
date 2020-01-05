//
//  AppAnimator.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 04/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import UIKit


class Animator:NSObject,UIViewControllerAnimatedTransitioning{
    
    let duration = 0.8
    var isPresenting = true
    var startingFrame:CGRect = .zero
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let intermediateView = isPresenting ? transitionContext.view(forKey: .to) : transitionContext.view(forKey: .from)
        let pincellview = isPresenting ? transitionContext.view(forKey: .to)! : transitionContext.view(forKey: .from)!
        
        let initialFrame = isPresenting ? startingFrame : pincellview.frame
        let endingFrame = isPresenting ? pincellview.frame : startingFrame
        
        let scaleX = isPresenting ? initialFrame.width / endingFrame.width : endingFrame.width / initialFrame.width
        let scaleY = isPresenting ? initialFrame.height / endingFrame.height : endingFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        if isPresenting{
            pincellview.transform = scaleTransform
            pincellview.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            
        }else{
            pincellview.alpha = 0
        }
        
        containerView.addSubview(intermediateView!)
        containerView.bringSubviewToFront(pincellview)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2,  options: .curveEaseInOut, animations: {
            pincellview.transform = self.isPresenting ? .identity : scaleTransform
            pincellview.center = CGPoint(x: endingFrame.midX, y: endingFrame.midY)
            
        }) { _ in
            
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionForDismissing(context:UIViewControllerContextTransitioning){
        
        
        
    }
    
}
