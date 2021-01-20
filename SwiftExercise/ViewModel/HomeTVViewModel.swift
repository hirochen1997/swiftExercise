//
//  HomeTVViewModel.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeTVViewModel: NSObject {
    
    var datas: [HomeTVViewData] = []

    
    func fetchData(handle: @escaping ()->Void) {
        weak var weakRef = self
        SENetworkHelper.httpGetRequest("http://localhost:12306/homeTV", callback: {(arr: Array<Dictionary>)->Void in
            for _ in 0..<onceLoadNum {
                let pos = Int(arc4random()) % arr.count
                var tempData = HomeTVViewData()
                tempData.tvURL = arr[pos]["url"] as! String
                tempData.userName = arr[pos]["userName"] as! String
                weakRef?.datas.append(tempData)
            }
            handle() // 回调通知view数据已经拉取完成
        })
    
    }
    
    
}
