//
//  HomeTVViewModel.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeTVViewModel: NSObject {
    
    var datas: [HomeTVViewData] = []
    
    override init() {
        super.init()
        fetchData()
    }
    
    func fetchData() {
        // 拉取关注模块的数据
        for _ in 0..<onceLoadNum {
            let t_data = HomeTVViewData(tvURL: "https://v-cdn.zjol.com.cn/280443.mp4", userName: "@叫什么名字好呢")
            datas.append(t_data)
        }
    }
    
    
}
