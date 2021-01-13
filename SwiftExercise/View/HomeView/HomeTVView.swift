//
//  HomeTVView.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit
import AVKit

class HomeTVView: UIView, UITableViewDelegate, UITableViewDataSource {

    var viewModel = HomeTVViewModel()
    var canRefresh = false
    let tableView = UITableView()
    var firstAppear = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTVView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTVView() {
        tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-2*buttonHeight-AppDelegate.tabHeight)
        
        tableView.backgroundColor = UIColor.gray
        tableView.isScrollEnabled = true
        tableView.isPagingEnabled = true
        tableView.rowHeight = kScreenHeight-2*buttonHeight-AppDelegate.tabHeight
        tableView.estimatedRowHeight = 0
        //tableView.showsVerticalScrollIndicator = false
        
        tableView.register(HomeTVViewCell.self, forCellReuseIdentifier: "tvCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.addSubview(tableView)
        
        
    }
    
    // 关闭当前显示的cell的TV播放
    func stopTV() {
        let visibleCells = tableView.visibleCells
        for cell in visibleCells {
            (cell as! HomeTVViewCell).playerLayer.player?.pause()
        }
    }
    
    // 重新播放当前显示的cell的tv
    func startTV() {
        let visibleCells = tableView.visibleCells
        for cell in visibleCells {
            (cell as! HomeTVViewCell).playerLayer.player?.seek(to: CMTimeMake(value: 0, timescale: 1))
            (cell as! HomeTVViewCell).playerLayer.player?.play()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 结束显示时停止当前cell的tv播放
        (cell as! HomeTVViewCell).playerLayer.player?.pause()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tvCell", for: indexPath) as! HomeTVViewCell
        
        cell.userName.text = viewModel.datas[indexPath.row].userName
        cell.setTV(tvURL: viewModel.datas[indexPath.row].tvURL)
        cell.frame.size.height = tableView.rowHeight
        if firstAppear {
            cell.playerLayer.player?.play()
            firstAppear = false
        }
        
        return cell
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y == 0 && canRefresh {
            canRefresh = false
            viewModel.datas.removeAll()
            viewModel.fetchData()
            (scrollView as! UITableView).layoutIfNeeded()
            (scrollView as! UITableView).reloadData()
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
            (scrollView as! UITableView).reloadData()
            print("more data")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 当某个cell刚好完全出现时开始播放tv
        startTV()
    }
    
}
