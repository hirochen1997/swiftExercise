//
//  HomeFreshViewModel.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeFreshViewModel: NSObject {
    var datas: [HomeShortVideoViewData] = []
    
    func fetchData(handle: @escaping ()->Void) {
        weak var weakRef = self
        SENetworkHelper.httpGetRequest("http://localhost:12306/homeFresh", callback: {(arr: Array<Dictionary>)->Void in
            for _ in 0..<onceLoadNum {
                let pos = Int(arc4random()) % arr.count
                var tempData = HomeShortVideoViewData()
                tempData.videoURL = arr[pos]["url"] as! String
                tempData.useName = arr[pos]["userName"] as! String
                tempData.title = arr[pos]["title"] as! String
                
                let publishTime = Int(arr[pos]["time"] as! String)!
                if publishTime < 24 {
                    tempData.info = String(publishTime) + "小时前"
                } else {
                    tempData.info = String(publishTime / 24) + "天前"
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
