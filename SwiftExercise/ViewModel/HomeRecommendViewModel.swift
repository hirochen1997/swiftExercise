//
//  HomeRecommendViewModel.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeRecommendViewModel: NSObject {
    
    var datas: [HomeShortVideoViewData] = []
    
    override init() {
        super.init()
        fetchData() // 拉取初始数据
    }
    
    func fetchData() {
        for _ in 0..<onceLoadNum {
            var t_data = HomeShortVideoViewData(videoFrameImgURL: "", useName: "名字太长了爱神的箭佛", info: "", userImgURL: "", title: "")
            
            // 读取数据
            let watchAmount = arc4random() % 10000000
            if watchAmount < 10000 {
                t_data.info = "播放量：" + String(watchAmount)
            }
            else {
                t_data.info = "播放量：" + String(watchAmount/10000) + "万"
            }
            
            let hasTitle = arc4random() % 2
            if hasTitle == 1 {
                t_data.title = "艾斯欧地方就是董非农你好收水电费你你你欧马可到佛安防部！！"
            }
            else {
                t_data.title = ""
            }
            datas.append(t_data)
        }
    }
    
    
}
