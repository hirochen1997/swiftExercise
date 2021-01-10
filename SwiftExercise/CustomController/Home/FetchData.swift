//
//  ShortVideoLayout.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/8.
//

import UIKit

class FetchData {
    static func fetchData(kind: Int)->[Any] {
        switch kind {
        case 0:
            // 拉取关注模块的数据
            var dataList:[HomeFollowViewData] = []
            for i in 0..<10 {
                var t_data = HomeFollowViewData(userName: "取个什么名字", fansCount: "", isFollow: false, userImgURL: "", showListURLs: [])
                
                // 随机生成数据
                let fansNum = arc4random() % 10000000
                if fansNum < 10000 {
                    t_data.fansCount = "粉丝数：" + String(fansNum)
                }
                else {
                    t_data.fansCount = "粉丝数：" + String(fansNum / 10000) + "万"
                }
                dataList.append(t_data)
            }
            return dataList
            
        case 1:
            // 拉取新鲜模块的数据
            var dataList:[HomeShortVideoViewData] = []
            for i in 0..<10 {
                var t_data = HomeShortVideoViewData(videoFrameImgURL: "", useName: "取个什么名字好呢", info: "", userImgURL: "", title: "")
                
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
                dataList.append(t_data)
            }
            return dataList
            
        case 2:
            // 拉取推荐模块的数据
            var dataList:[HomeShortVideoViewData] = []
            for i in 0..<10 {
                var t_data = HomeShortVideoViewData(videoFrameImgURL: "", useName: "", info: "", userImgURL: "", title: "")
                
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
                dataList.append(t_data)
            }
            return dataList
            
        default:
            return []
        }
    }
}
