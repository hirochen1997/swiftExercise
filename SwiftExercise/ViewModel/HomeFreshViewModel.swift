//
//  HomeFreshViewModel.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeFreshViewModel: NSObject {
    var datas: [HomeShortVideoViewData] = []
    
    override init() {
        super.init()
        fetchData() // 拉取初始数据
    }
    
    func fetchData() {
        for _ in 0..<onceLoadNum {
            var t_data = HomeShortVideoViewData(videoFrameImgURL: "", useName: "取\(datas.count)", info: "", userImgURL: "", title: "")
            
            // 读取数据
            let publishTime = arc4random() % 100
            if publishTime < 24 {
                t_data.info = String(publishTime) + "小时前"
            }
            else {
                t_data.info = String(publishTime/24) + "天前"
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
