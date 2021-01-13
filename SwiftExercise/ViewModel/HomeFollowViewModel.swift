//
//  HomeFollowViewModel.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeFollowViewModel: NSObject {
    var datas: [HomeFollowViewData] = []
    
    override init() {
        super.init()
        fetchData() // 拉取初始数据
    }
    
    func fetchData() {
        // 拉取关注模块的数据
        for _ in 0..<onceLoadNum {
            var t_data = HomeFollowViewData(userName: "取个什么名字", fansCount: "", isFollow: false, userImgURL: "", showListURLs: [])
            
            // 随机生成数据
            let fansNum = datas.count//arc4random() % 10000000
            if fansNum < 10000 {
                t_data.fansCount = "粉丝数：" + String(fansNum)
            }
            else {
                t_data.fansCount = "粉丝数：" + String(fansNum / 10000) + "万"
            }
            datas.append(t_data)
        }
    }
    
    
}


