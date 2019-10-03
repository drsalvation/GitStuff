//
//  TransitionAnimationsThingy.swift
//  RomanSixPokemons
//
//  Created by MCS on 10/2/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation
import UIKit

class TransitionAnimationsThingy: NSObject, UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let secondViewController: SecondViewController
        var willItBeShown = false
        if let secondVC = transitionContext.viewController(forKey: .to) as? SecondViewController{
            secondViewController = secondVC
            willItBeShown = true
        } else if let secondVC = transitionContext.viewController(forKey: .from) as? SecondViewController{
            secondViewController = secondVC
            willItBeShown=false
        } else {
            print("what the heck? There's just 2 possible outcomes and YET you managed to get neither of them!?")
            return
        }
        
        guard let secondView = secondViewController.view else {return}
        transitionContext.containerView.addSubview(secondView)
        if willItBeShown {
            secondView.frame.origin = CGPoint(x: -UIScreen.main.bounds.width, y: UIScreen.main.bounds.height)
        } else {
            secondView.frame.origin = CGPoint.zero
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if willItBeShown{
                secondView.frame.origin = CGPoint.zero
            } else {
                secondView.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height)
            }
        }) { (complete) in
            transitionContext.completeTransition(complete)
        }
    }
}
