//
//  AnimatorFactory.swift
//  Widgets
//
//  Created by 夏语诚 on 2018/6/20.
//  Copyright © 2018年 Banana. All rights reserved.
//

import UIKit

class AnimatorFactory {
    static func scaleUp(view: UIView) -> UIViewPropertyAnimator {
        let scale = UIViewPropertyAnimator(duration: 0.33, curve: .easeIn, animations: nil)
        scale.addAnimations {
            view.alpha = 1.0
        }
        scale.addAnimations({
            view.transform = CGAffineTransform.identity
        }, delayFactor: 0.33)
        scale.addCompletion { _ in
            print("ready")
        }
        return scale
    }
    
    @discardableResult
    static func jiggle(view: UIView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.33, delay: 0, animations: {
            UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                    view.transform = CGAffineTransform(rotationAngle: -.pi / 8)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75, animations: {
                    view.transform = CGAffineTransform(rotationAngle: +.pi / 8)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1.0, animations: {
                    view.transform = CGAffineTransform.identity
                })
            }, completion: nil)
        }, completion: { _ in
            view.transform = .identity
        })
    }
    
    @discardableResult
    static func fade(view: UIView, visible: Bool) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            view.alpha = visible ? 1.0 : 0.0
        }, completion: nil)
    }
    
    @discardableResult
    static func animateConstraint(view: UIView, constraint: NSLayoutConstraint, by: CGFloat) -> UIViewPropertyAnimator {
        let spring = UISpringTimingParameters(dampingRatio: 0.55)
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
        
        animator.addAnimations {
            constraint.constant += by
            view.layoutIfNeeded()
        }
        return animator
    }
    
    static func grow(view: UIVisualEffectView, blurView: UIVisualEffectView) -> UIViewPropertyAnimator {
        // 1
        view.contentView.alpha = 0
        view.transform = .identity
        
        // 2
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn, animations: nil)
        
        // 3
        animator.addAnimations {
//            blurView.effect = UIBlurEffect(style: .dark)
//            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    blurView.effect = UIBlurEffect(style: .dark)
                    view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    view.transform = view.transform.rotated(by: -.pi / 8)
                })
            }, completion: nil)
        }
        
        // 4
        animator.addCompletion { position in
//            blurView.effect = UIBlurEffect(style: .dark)
            switch position {
            case .start:
                blurView.effect = nil
            case .end:
                blurView.effect = UIBlurEffect(style: .dark)
            default:
                break
            }
        }
        
        return animator
    }
    
    static func reset(frame: CGRect, view: UIVisualEffectView, blurView: UIVisualEffectView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.7, animations: {
            view.transform = .identity
            view.frame = frame
            view.contentView.alpha = 0
            
            blurView.effect = nil
        })
    }
    
    static func complete(view: UIVisualEffectView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.7, animations: {
            view.contentView.alpha = 1
            view.transform = .identity
            view.frame = CGRect(x: view.frame.minX - view.frame.minX / 2.5,
                                y: view.frame.maxY - 140,
                                width: view.frame.width + 120,
                                height: 60)
        })
    }
}
