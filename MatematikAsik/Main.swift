//
//  ViewController.swift
//  MatematikaAsik
//
//  Created by Afriyandi Setiawan on 22/03/19.
//  Copyright © 2019 Afriyandi Setiawan. All rights reserved.
//

import UIKit

struct ViewControllerList {
    
    static var addingPage: UIViewController {
        let addVC = CalculateViewController()
        addVC.tabBarItem = UITabBarItem(title: "Add", image: UIImage(named: "add"), selectedImage: UIImage(named: "add"))
        let nv = UINavigationController(rootViewController: addVC)
        return nv
    }
    
    static var multiplyPage: UIViewController {
        let mulVC = CalculateViewController()
        mulVC.operationType = .multiply
        mulVC.tabBarItem = UITabBarItem(title: "Multiply", image: UIImage(named: "multiply"), selectedImage: UIImage(named: "multiply"))
        let nv = UINavigationController(rootViewController: mulVC)
        return nv
    }
    
    static var fibonacciPage: UIViewController {
        let mulVC = CalculateViewController()
        mulVC.operationType = .findFibonacci
        mulVC.tabBarItem = UITabBarItem(title: "Fibonacci", image: UIImage(named: "fibonacci"), selectedImage: UIImage(named: "fibonacci"))
        let nv = UINavigationController(rootViewController: mulVC)
        return nv
    }
    
    static var primePage: UIViewController {
        let mulVC = CalculateViewController()
        mulVC.operationType = .findPrimeNumber
        mulVC.tabBarItem = UITabBarItem(title: "Prime Number", image: UIImage(named: "prime"), selectedImage: UIImage(named: "prime"))
        let nv = UINavigationController(rootViewController: mulVC)
        return nv
    }


}

class Main: UITabBarController {
    
    lazy var tabMember:[UIViewController]? = {
        return [ViewControllerList.addingPage,
                ViewControllerList.multiplyPage,
                ViewControllerList.primePage,
                ViewControllerList.fibonacciPage
                ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = tabMember
    }


}

