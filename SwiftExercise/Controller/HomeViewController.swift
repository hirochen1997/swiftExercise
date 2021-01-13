//
//  HomeViewController.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/5.
//
import UIKit

class HomeViewController: UIViewController {
    let homeView = HomeView()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        print("首页!!!")
        
        homeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(homeView)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 如果此时正好是tv模块，就重新播放tv
        if homeView.contentScrollView.contentOffset.x == homeView.homeTVView.frame.origin.x {
            homeView.homeTVView.startTV()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 切换其他模块时关闭正在播放的tv
        homeView.homeTVView.stopTV()
    }
}


