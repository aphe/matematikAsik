//
//  CalculateViewController.swift
//  MatematikaAsik
//
//  Created by Afriyandi Setiawan on 22/03/19.
//  Copyright © 2019 Afriyandi Setiawan. All rights reserved.
//

import UIKit

class CalculateViewController: FormViewController {

    @IBOutlet weak var nextButton: UIButton!
    private var currentNumber: Int?
    private var previousNumber: Int?
    var operationType: OperationType = .add
    var pageTitle: String = "Input The First Number"
    
    lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 50)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isBeingPresented && !isMovingToParent {
            let tf = self.view.subviews.filter { (v) -> Bool in
                v is UITextField
                }.first as? UITextField
            tf?.text = ""
            self.view.backgroundColor = .white
        }
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        sender.limitLength()
        DispatchQueue.main.async {
            self.view.backgroundColor = .random
            self.nextButton.setTitleColor(.random, for: .normal)
            if let doubleVal = Int(sender.text?.digits ?? "") {
                self.currentNumber = doubleVal
                sender.text = doubleVal.commaRepresentation
            }
        }
    }
    
    @IBAction func doNext(_ sender: UIButton) {
        calculate()
    }
    
    func setupView() {
        switch operationType {
        case .add, .multiply:
            self.navigationItem.title = pageTitle;
            previousNumber == nil ? () : nextButton.setTitle("Calculate", for: .normal)
        case .findPrimeNumber, .findFibonacci:
            self.navigationItem.title = "Input Number";
            nextButton.setTitle("Calculate", for: .normal)
        }
    }
    
    func calculate() {
        switch operationType {
        case .add, .multiply:
            addOrMultiplyOp()
        case .findFibonacci:
            findFibonacci()
        case .findPrimeNumber:
            findPrimeNumber()
        }

    }
    
    func findFibonacci() {
        guard let current = currentNumber else {
            return
        }
        func dFib(_ n: Int64) -> [Int64] {
            var a:Int64 = 0, b:Int64 = 1, fib = [a]
            guard n > 1 else {
                return [a]
            }
            (2...n).forEach { _ in
                (a, b) = (a + b, a)
                fib.append(a)
            }
            return fib
        }
        let vc = ResultCollectionViewController(collectionViewLayout: collectionLayout)
        vc.hidesBottomBarWhenPushed = true
        vc.data = dFib(Int64(current)).sorted()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func findPrimeNumber() {
    }
    
    func addOrMultiplyOp() {
        func insertNextNumber() {
            guard let current = currentNumber else {
                return
            }
            let vc = CalculateViewController()
            vc.operationType = operationType
            vc.previousNumber = current
            let prefix = operationType == .add ? " Add to" : " Multiply to"
            vc.pageTitle = current.commaRepresentation + prefix
            vc.view.backgroundColor = self.view.backgroundColor
            vc.nextButton.setTitleColor(vc.nextButton.titleColor(for: .normal), for: .normal)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        func calculate() {
            guard let previous = previousNumber, let current = currentNumber else {
                return
            }
            var result = 0
            switch operationType {
            case .add:
                result = previous + current
            case .multiply:
                result = previous * current
            default:
                break
            }
            let alert = UIAlertController(title: "Result", message: result.commaRepresentation, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Nice", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(okButton)
            self.present(alert, animated: true) {}
        }
        previousNumber == nil ? insertNextNumber() : calculate()
    }
    
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var words: String {
        return components(separatedBy: .punctuationCharacters)
            .joined()
    }
}

extension Int {
    static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    internal var commaRepresentation: String {
        return Int.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Int64 {
    internal var commaRepresentation: String {
        return Int.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}


extension UITextField {
    private var maxLength: Int {
        return 9
    }
    func limitLength() {
        guard let prospectiveText = self.text?.words,
            prospectiveText.count >= maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String(prospectiveText[..<maxCharIndex])
        selectedTextRange = selection
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
