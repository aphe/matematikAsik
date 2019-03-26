//
//  FormViewController.swift
//  Elevenia
//
//  Created by Afriyandi Setiawan on 06/03/19.
//  Copyright © 2018 Elevenia. All rights reserved.
//

import UIKit

enum OperationType {
    case add
    case multiply
    case findPrimeNumber
    case findFibonacci
}

class FormViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        let tapEndEditing = UITapGestureRecognizer()
        tapEndEditing.addTarget(self, action: #selector(self.tapEndEditing))
        self.view.addGestureRecognizer(tapEndEditing)
        NotificationCenter.default.addObserver(self, selector: #selector(FormViewController.keyboardWillSHow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FormViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    @objc
    func tapEndEditing() {
        self.view.endEditing(true)
    }

    @objc
    func keyboardWillSHow(_ sender: Notification) {
        guard let uInfo = sender.userInfo, let kboardSize = uInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let scrollView = self.view.subviews.filter { (sView) -> Bool in
            sView is UIScrollView
        }.first
        guard let sView = scrollView as? UIScrollView else {
            return
        }
        let kboardHeight = kboardSize.cgRectValue.height
        var contentInset = sView.contentInset
        contentInset.bottom = kboardHeight
        sView.contentInset = contentInset
    }

    @objc
    func keyboardWillHide(_ sender: Notification) {
        let scrollView = self.view.subviews.filter { (sView) -> Bool in
            sView is UIScrollView
            }.first
        guard let sView = scrollView as? UIScrollView else {
            return
        }
        sView.contentInset = UIEdgeInsets.zero
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

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
