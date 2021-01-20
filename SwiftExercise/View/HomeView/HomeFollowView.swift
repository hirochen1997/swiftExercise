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
    
    var collectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFollowView()
        weak var weakRef = self
        viewModel.fetchData(handle: { ()->Void in
            weakRef?.collectionView!.reloadData()
        })
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initFollowView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: kScreenWidth, height: kScreenWidth/2)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 2*buttonHeight),collectionViewLayout: layout)
        collectionView!.register(HomeFollowViewCell.self, forCellWithReuseIdentifier: "FollowCell") // 注册自定义的cell，从而可以在队列里复用
        
        collectionView!.delegate = self
        collectionView!.dataSource = self
        
        collectionView!.isPagingEnabled = false
        collectionView!.isScrollEnabled = true
        collectionView!.showsVerticalScrollIndicator = true
        collectionView!.backgroundColor = UIColor.white

        self.addSubview(collectionView!)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowCell", for: indexPath) as! HomeFollowViewCell
        
        let tempData = viewModel.datas[indexPath.row]
        cell.viewModel = viewModel
        cell.cellIndex = indexPath.row
        cell.userName.text = tempData.userName
        cell.fansCount.text = tempData.fansCount
        
        if tempData.isFollow {
            cell.followButton.isSelected = true
            cell.followButton.backgroundColor = .gray
        } else {
            cell.followButton.isSelected = false
            cell.followButton.backgroundColor = .orange
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth, height: kScreenWidth/2)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y == 0 && canRefresh {
            canRefresh = false
            viewModel.clear()
            weak var weakRef = self
            viewModel.fetchData(handle: {()->Void in
                weakRef?.collectionView?.reloadData()
            })
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
            weak var weakRef = self
            viewModel.fetchData(handle: {()->Void in
                weakRef?.collectionView?.reloadData()
            })
        }
    }
    
}
