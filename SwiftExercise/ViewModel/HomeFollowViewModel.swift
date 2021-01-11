//
//  HomeFollowViewModel.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeFollowViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var datas: [HomeFollowViewData] = []
    var canRefresh = false
    
    override init() {
        super.init()
        fetchData() // 拉取初始数据
    }
    
    func fetchData() {
        // 拉取关注模块的数据
        for _ in 0..<10 {
            var t_data = HomeFollowViewData(userName: "取个什么名字", fansCount: "", isFollow: false, userImgURL: "", showListURLs: [])
            
            // 随机生成数据
            let fansNum = arc4random() % 10000000
            if fansNum < 10000 {
                t_data.fansCount = "粉丝数：" + String(fansNum)
            }
            else {
                t_data.fansCount = "粉丝数：" + String(fansNum / 10000) + "万"
            }
            datas.append(t_data)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowCell", for: indexPath) as! HomeFollowViewCell
        
        let t_data = datas[indexPath.row]
        cell.userName.text = t_data.userName
        cell.fansCount.text = t_data.fansCount
        cell.isFollow = t_data.isFollow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth, height: kScreenWidth/2)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y == 0 && canRefresh {
            canRefresh = false
            (scrollView as! UICollectionView).layoutIfNeeded()
            (scrollView as! UICollectionView).reloadData()
            print("reload")
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 顶部上拉刷新
        if scrollView.contentOffset.y < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            canRefresh = true
        } else {
            canRefresh = false
        }
        
        
        // 底部只能滑到刚好显示当前最后一行的cell
        // 这里获取的tabHeight才是准确的，必须要用view的高度减去tabHeight才是view可视部分的高度
        let cellBottom = scrollView.contentSize.height - (scrollView.frame.height - AppDelegate.tabHeight)
        if scrollView.contentOffset.y > cellBottom {
            scrollView.setContentOffset(CGPoint(x: 0, y: cellBottom), animated: false)
        }
    }
}
