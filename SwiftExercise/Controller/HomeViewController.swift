//
//  HomeViewController.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/5.
//
import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        print("首页!!!")
        
        let homeView = HomeView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(homeView)
    }

}


