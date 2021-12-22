//
//  File.swift
//  TransitionAnimationDemo
//
//  Created by Elluminati  on 23/08/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import Foundation
import UIKit

protocol CustomTransitionOriginator
{
    var fromAnimatedSubviews: [UIView] { get }
}

protocol CustomTransitionDestination {
    var toAnimatedSubviews: [UIView] { get }
}

class CustomAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var duration : TimeInterval = 5.0
    var type: TransitionType
    enum TransitionType
    {
        case IntroToPhone
        case PhoneToIntro
    }
    
    init(type: TransitionType)
    {
        self.type = type
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      
        
        let fromVC = transitionContext.viewController(forKey: .from) as! CustomTransitionOriginator  & UIViewController
        let toVC   = transitionContext.viewController(forKey: .to)   as! CustomTransitionDestination & UIViewController
        let container = transitionContext.containerView
        toVC.view.frame = fromVC.view.frame
        switch type
        {
        case .IntroToPhone:
           
            container.addSubview(toVC.view)
             toVC.view.layoutIfNeeded()
            let fromSnapshots = fromVC.fromAnimatedSubviews.map { subview -> UIView in
                let snapshot = subview.snapshotView(afterScreenUpdates: true)!
                snapshot.frame = container.convert(subview.frame, from: subview.superview)
                return snapshot
            }
            let toSnapshots = toVC.toAnimatedSubviews.map { subview -> UIView in
                let snapshot = subview.snapshotView(afterScreenUpdates: true)!// UIImageView(image: subview.snapshot())
                 snapshot.frame = container.convert(subview.frame, from: subview.superview)
                return snapshot
            }
            let frames = zip(fromSnapshots, toSnapshots).map { ($0.frame, $1.frame) }
            
            let alphaView:UIView = UIView.init(frame: fromVC.view.frame)
            alphaView.backgroundColor = UIColor.white
            alphaView.alpha = 1.0
            // move the "to" snapshots to where where the "from" views were, but hide them for now
            
            zip(toSnapshots, frames).forEach { snapshot, frame in
                snapshot.frame = frame.0
                snapshot.alpha = 0
                //alphaView.addSubview(snapshot)
            }
            
            // add "from" snapshots, too, but hide the subviews that we just snapshotted
            // associated labels so we only see animated snapshots; we'll unhide these
            // original views when the animation is done.
            
            fromSnapshots.forEach {
                alphaView.addSubview($0)
                
            }
            
            container.addSubview(alphaView)
         
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                // animate the snapshots of the label
                
                zip(fromSnapshots, frames).forEach { snapshot, frame in
                    snapshot.frame = frame.1
                    snapshot.alpha = 1
                }
                
            }, completion: { _ in
                // get rid of snapshots and re-show the original labels
                
                fromSnapshots.forEach { $0.removeFromSuperview() }
              //  toSnapshots.forEach   { $0.removeFromSuperview() }
                
                alphaView.removeFromSuperview()
                
                fromVC.fromAnimatedSubviews.forEach { $0.alpha = 1 }
                toVC.toAnimatedSubviews.forEach { $0.alpha = 1 }
               
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            break;
        case .PhoneToIntro:
            toVC.view.layoutIfNeeded()
            container.insertSubview(toVC.view, belowSubview: fromVC.view)
            break;
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}

    

    

    

    



class PresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool { return true }
}
