//
//  AppDelegate.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/5.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var tabHeight: CGFloat = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // 初始化window
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        

        // 初始化每个标签页对应的ViewController
        let HomeVC = HomeViewController()
        let FoundVC = FoundViewController()
        let MessageVC = MessageViewController()
        let MineVC = MineViewController()
        
        // 设置每个标签页的标题
        HomeVC.tabBarItem.title = "首页"
        FoundVC.tabBarItem.title = "发现"
        MessageVC.tabBarItem.title = "信息"
        MineVC.tabBarItem.title = "我的"
        
        // 将标签页对应的ViewController放入UITabBarController
        let tabBar = UITabBarController()
        tabBar.viewControllers = [HomeVC, FoundVC, MessageVC, MineVC]
        tabBar.tabBar.backgroundColor = UIColor.blue
        // 将window的根视图设置为tabBar,并设置为key window
        self.window?.rootViewController = tabBar
        self.window!.makeKeyAndVisible()
        AppDelegate.tabHeight = tabBar.tabBar.bounds.height
        print("init")
        
        
        return true
    }

    


}

