//
//  AppDelegate.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/5.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let buttonHeight = CGFloat(50)
let onceLoadNum = 20
let fetchNewDataWhenCellFirstAppear = 4 // 倒数第几个cell出现时需要重新拉取数据从而无限滑屏

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var tabHeight: CGFloat = 83
    static let tabBarController = UITabBarController()
    static var homeNavigationVC: UINavigationController!
    static var videoPlayVC = SEVideoPlayController()
    
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
        
        
        // 设置主页的导航vc
        AppDelegate.homeNavigationVC = UINavigationController(rootViewController: HomeVC)
        AppDelegate.homeNavigationVC.navigationBar.isHidden = true
        
        
        // 设置每个标签页的标题
        AppDelegate.homeNavigationVC.tabBarItem.title = "首页"
        FoundVC.tabBarItem.title = "发现"
        MessageVC.tabBarItem.title = "信息"
        MineVC.tabBarItem.title = "我的"
        
        // 将标签页对应的ViewController放入UITabBarController
        AppDelegate.tabBarController.viewControllers = [AppDelegate.homeNavigationVC, FoundVC, MessageVC, MineVC]
        AppDelegate.tabBarController.tabBar.backgroundColor = UIColor.blue

        
        // 将window的根视图设置为tabBar,并设置为key window
        self.window?.rootViewController = AppDelegate.tabBarController
        self.window!.makeKeyAndVisible()
        
        print(AppDelegate.tabHeight)
        print("init")
        
        
        return true
    }

    


}

