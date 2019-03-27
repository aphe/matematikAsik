//
//  ExtensionCompilation.swift
//  MatematikAsik
//
//  Created by Afriyandi Setiawan on 27/03/19.
//  Copyright © 2019 Afriyandi Setiawan. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as? T
    }
}

extension UIViewController {
    private struct SpinnerStruct {
        static var background = UIView(frame: CGRect.zero)
    }
    
    var spinnerBackground: UIView? {
        get {
            return objc_getAssociatedObject(self, &SpinnerStruct.background) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &SpinnerStruct.background, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc
    func showSpinner() {
        spinnerBackground = UIView(frame: UIScreen.main.bounds)
        spinnerBackground?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        if let spinnerBG = spinnerBackground {
            let spinner = UIActivityIndicatorView(style: .whiteLarge)
            spinner.startAnimating()
            let templateView = self.navigationController != nil ? self.navigationController?.view : self.view
            spinner.center = templateView?.center ?? CGPoint.zero
            
            DispatchQueue.main.async {
                self.spinnerBackground?.addSubview(spinner)
                spinnerBG.center = self.navigationController?.view.center ?? self.view.center
                templateView?.addSubview(spinnerBG)
            }
        }
    }
    
    func hideSpinner() {
        if let spinnerBG = spinnerBackground {
            spinnerBG.removeFromSuperview()
        }
    }
}

extension UIWindow {
    public var visibleViewController: UIViewController? {
        return self.visibleViewController(from: rootViewController)
    }
    
    func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return self.visibleViewController(from: navigationController.visibleViewController)
        case let tabBarController as UITabBarController:
            return self.visibleViewController(from: tabBarController.selectedViewController)
        case let presentingViewController where
            viewController?.presentedViewController != nil:
            return self.visibleViewController(from: presentingViewController?.presentedViewController)
        default:
            return viewController
        }
    }
    
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}

extension UIAlertController {
    
    func show(animate: Bool = true, completion: (() -> Void)? = nil) {
        presentCustom(animated: animate, completion: completion)
    }
    
    func showToast(animated: Bool, duration: Double, completion: (() -> Void)?) {
        presentCustom(animated: animated) {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                self.dismiss(animated: animated, completion: completion)
            })
        }
    }
    
    func presentCustom(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.visibleViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let presented = controller.presentedViewController {
            presented.present(self, animated: animated, completion: completion)
            return
        }
        switch controller {
        case let navVC as UINavigationController:
            presentFromController(controller: navVC.visibleViewController!, animated: animated, completion: completion)
        case let tabVC as UITabBarController:
            presentFromController(controller: tabVC.selectedViewController!, animated: animated, completion: completion)
        case _ as UIAlertController:
            return
        default:
            controller.present(self, animated: animated, completion: completion)
        }
    }
}

func showToast(withMessage message: String?, duration: Double? = nil) {
    showToast(withMessage: message, duration: duration, completion: nil)
}

func showToast(withMessage message: String?, duration: Double? = nil, completion: (() -> Void)?) {
    let duration = duration == nil ? 2 : duration!
    let alert = UIAlertController(title: nil, message: message ?? "Undefined Error", preferredStyle: .alert)
    alert.showToast(animated: true, duration: duration, completion: completion)
}


extension UINavigationController {
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
    func popViewController(
        animated: Bool,
        completion: @escaping () -> Void) {
        popViewController(animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
