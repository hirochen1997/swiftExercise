//
//  HomeTVView.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit
import AVKit

class HomeTVView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let viewModel = HomeTVViewModel()
    var collectionView: UICollectionView?
    
    var canRefresh = false
    var firstAppear = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTVView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTVView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight-2*buttonHeight-AppDelegate.tabHeight)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-2*buttonHeight-AppDelegate.tabHeight), collectionViewLayout: layout) 
        
        collectionView!.isScrollEnabled = true
        collectionView!.isPagingEnabled = true
        collectionView!.showsVerticalScrollIndicator = false
        
        collectionView!.register(HomeTVViewCell.self, forCellWithReuseIdentifier: "tvCell")
        
        collectionView!.delegate = self
        collectionView!.dataSource = self
        
        self.addSubview(collectionView!)
        
        
    }
    
    // 关闭当前显示的cell的TV播放
    func stopTV() {
        let visibleCells = collectionView!.visibleCells
        for cell in visibleCells {
            (cell as! HomeTVViewCell).playerLayer.player?.pause()
            (cell as! HomeTVViewCell).isPlaying = false
            (cell as! HomeTVViewCell).playButton.setImage(UIImage(named: "play.jpg"), for: .normal)
        }
    }
    
    // 重新播放当前显示的cell的tv
    func startTV() {
        let visibleCells = collectionView!.visibleCells
        for cell in visibleCells {
            (cell as! HomeTVViewCell).playerLayer.player?.seek(to: CMTimeMake(value: 0, timescale: 1))
            (cell as! HomeTVViewCell).playerLayer.player?.play()
            (cell as! HomeTVViewCell).isPlaying = true
            (cell as! HomeTVViewCell).playButton.setImage(UIImage(named: "stop.jpg"), for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvCell", for: indexPath) as! HomeTVViewCell
        
        cell.userName.text = viewModel.datas[indexPath.row].userName
        cell.setTV(tvURL: viewModel.datas[indexPath.row].tvURL)
        
        if firstAppear {
            cell.playerLayer.player?.play()
            cell.isPlaying = true
            cell.playButton.setImage(UIImage(named: "stop.jpg"), for: .normal)
            firstAppear = false
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! HomeTVViewCell).playerLayer.player?.pause()
        (cell as! HomeTVViewCell).playerLayer.player?.seek(to: CMTimeMake(value: 0, timescale: 1))
        (cell as! HomeTVViewCell).isPlaying = false
        (cell as! HomeTVViewCell).playButton.setImage(UIImage(named: "play.jpg"), for: .normal)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y == 0 && canRefresh {
            canRefresh = false
            viewModel.datas.removeAll()
            viewModel.fetchData()
            (scrollView as! UICollectionView).layoutIfNeeded()
            (scrollView as! UICollectionView).reloadData()
            firstAppear = true
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
        let cellBottom = scrollView.contentSize.height - scrollView.frame.height
        if scrollView.contentOffset.y > cellBottom {
            scrollView.setContentOffset(CGPoint(x: 0, y: cellBottom), animated: false)
            // 拉取新的数据，实现向下滚动无限刷新
            viewModel.fetchData()
            (scrollView as! UICollectionView).reloadData()
            print("more data")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 当某个cell刚好完全出现时开始播放tv
        startTV()
    }
    
    
    
}
