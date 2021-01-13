//
//  HomeFollowView.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeFollowView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let viewModel = HomeFollowViewModel()
    var canRefresh = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFollowView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initFollowView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: kScreenWidth, height: kScreenWidth/2)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 2*buttonHeight),collectionViewLayout: layout)
        collectionView.register(HomeFollowViewCell.self, forCellWithReuseIdentifier: "FollowCell") // 注册自定义的cell，从而可以在队列里复用
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white

        self.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowCell", for: indexPath) as! HomeFollowViewCell
        
        let t_data = viewModel.datas[indexPath.row]
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
            viewModel.datas.removeAll()
            viewModel.fetchData()
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
            // 拉取新的数据，实现向下滚动无限刷新
            viewModel.fetchData()
            (scrollView as! UICollectionView).reloadData()
            (scrollView as! UICollectionView).collectionViewLayout.invalidateLayout()
        }
    }
    
}
