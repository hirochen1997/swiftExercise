//
//  HomeFollowViewModel.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeFollowViewModel: NSObject {
    var datas: [HomeFollowViewData] = []
    var jsonData: Array<Dictionary<String, String>>!
    var dataIndexToJsonDataIndex: [Int] = []
    
    func fetchData(handle: @escaping ()->Void) {
        // 拉取关注模块的数据
        weak var weakRef = self
        SENetworkHelper.httpGetRequest("http://localhost:12306/homeFollow", callback: { (arr: Array<Dictionary>)->Void in
            for _ in 0..<onceLoadNum {
                let pos = Int(arc4random()) % arr.count
                var tempData = HomeFollowViewData()
                tempData.userName = arr[pos]["name"] as! String
                
                let fansCount = Int(arr[pos]["fansCount"] as! String)!
                if fansCount < 10000 {
                    tempData.fansCount = "粉丝数：\(fansCount)"
                } else {
                    tempData.fansCount = "粉丝数：\(fansCount / 10000)万"
                }
                 
                
                let isFollow = arr[pos]["follow"] as! String
                if isFollow == "true" {
                    tempData.isFollow = true
                } else {
                    tempData.isFollow = false
                }
                
                weakRef?.datas.append(tempData)
                weakRef?.dataIndexToJsonDataIndex.append(pos)
            }
            weakRef?.jsonData = arr as? Array<Dictionary<String, String>>
            handle() // 回调通知view数据已经拉取完成
        })
    }
    
    func uploadData(index: Int, value: String, handle: @escaping ()->Void) {
        weak var weakRef = self
        SENetworkHelper.httpPostRequest("http://localhost:12306/homeFollow", callback: {()->Void in
            weakRef?.jsonData[weakRef!.dataIndexToJsonDataIndex[index]]["follow"] = value
            
            let outputStream = OutputStream.init(toFileAtPath: "/Users/hiro/Documents/testServer/followModule/followList.json", append: false)
            outputStream?.open()
            
            JSONSerialization.writeJSONObject(weakRef!.jsonData!, to: outputStream!, options: .prettyPrinted, error: nil)
            
            
            outputStream?.close()
            handle()
        })
    }
    
    func clear() {
        datas.removeAll()
        dataIndexToJsonDataIndex.removeAll()
    }
    
}


