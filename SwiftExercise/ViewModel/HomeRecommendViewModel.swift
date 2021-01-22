//
//  HomeRecommendViewModel.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeRecommendViewModel: NSObject {
    
    var datas: [HomeShortVideoViewData] = []
    
    func fetchData(handle: @escaping ()->Void) {
        weak var weakRef = self
        SENetworkHelper.httpGetRequest("http://localhost:12306/homeRecommend", callback: {(arr: Array<Dictionary>)->Void in
            for _ in 0..<onceLoadNum {
                let pos = Int(arc4random()) % arr.count
                var tempData = HomeShortVideoViewData()
                tempData.videoURL = arr[pos]["url"] as! String
                tempData.useName = arr[pos]["userName"] as! String
                tempData.title = arr[pos]["title"] as! String
                
                let watchAmount = Int(arr[pos]["watch"] as! String)!
                if watchAmount < 10000 {
                    tempData.info = "播放量：" + String(watchAmount)
                }
                else {
                    tempData.info = "播放量：" + String(watchAmount/10000) + "万"
                }
                
                let urlStr = NSURL(string: arr[pos]["videoImg"] as! String)!
                let data = NSData(contentsOf: urlStr as URL)!
                tempData.videoFrameImg = UIImage(data: data as Data)!
                
                weakRef?.datas.append(tempData)
            }
            handle() // 回调通知view数据已经拉取完成
        })
    }
    
    
}
