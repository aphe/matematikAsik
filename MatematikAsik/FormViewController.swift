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
