//
//  HomeFreshView.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeFreshView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let viewModel = HomeFreshViewModel()
    var canRefresh = false
    var freshCellBottom: [CGFloat] = [0,0]
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initShortVideoView()
        weak var weakRef = self
        viewModel.fetchData(handle: { ()->Void in
            weakRef?.collectionView!.reloadData()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initShortVideoView() {
        let layout = ShortVideoCollectionViewLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = HomeShortVideoViewCell.minimumLineSpacing
        layout.minimumInteritemSpacing = HomeShortVideoViewCell.minimumInteritemSpacing
        layout.sectionInset = HomeShortVideoViewCell.sectionInset
        layout.estimatedItemSize = CGSize(width: (kScreenWidth-layout.minimumInteritemSpacing-layout.sectionInset.left-layout.sectionInset.right)/2, height: kScreenWidth*0.8) // itemSize会固定，estimatedItemSize可以动态调整
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 2*buttonHeight), collectionViewLayout: layout)
        collectionView.register(HomeShortVideoViewCell.self, forCellWithReuseIdentifier: "ShortVideoCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.black
        //collectionView.bounces = false

        self.addSubview(collectionView)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortVideoCell", for: indexPath) as! HomeShortVideoViewCell

        // 初始化cell的设置，避免复用的cell受到之前设置的影响
        cell.initSetUp()
        
        // 将数据填充到cell
        let t_data = viewModel.datas[indexPath.row]
        cell.info.text = t_data.info
        cell.userName.text = t_data.useName
        cell.title.text = t_data.title
        cell.videoFrameImg.image = t_data.videoFrameImg
        
        // 调用重写的layoutSubViews动态修改部分view的frame
        cell.layoutSubviews()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        var textHeight = CGFloat(ceilf(Float(viewModel.datas[indexPath.row].title.boundingRect(with: CGSize(width: (kScreenWidth-HomeShortVideoViewCell.minimumInteritemSpacing-HomeShortVideoViewCell.sectionInset.left-HomeShortVideoViewCell.sectionInset.right)/2, height: 40), options: option, attributes: attributes, context: nil).height)))

        // 空字符串也会有高度，需要置为0
        if viewModel.datas[indexPath.row].title == "" {
            textHeight = 0
        }
        
        let width = (kScreenWidth-HomeShortVideoViewCell.minimumInteritemSpacing-HomeShortVideoViewCell.sectionInset.left-HomeShortVideoViewCell.sectionInset.right)/2
        let height = kScreenWidth*0.7+textHeight
        
        if indexPath.row == 0 {
            freshCellBottom[0] = 0
            freshCellBottom[1] = 0
            // 刷新layout的attribute数组
            (collectionViewLayout as! ShortVideoCollectionViewLayout).refreshLayoutAttributes()
        }
        
        freshCellBottom[indexPath.row % 2] += height + (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
        
        if indexPath.row == viewModel.datas.count - 2 || indexPath.row == viewModel.datas.count - 1 {
            freshCellBottom[indexPath.row % 2] -= (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
        }
        
        // 设置当前cell的layout
        (collectionViewLayout as! ShortVideoCollectionViewLayout).setLayoutAttributesForItem(at: indexPath, size: CGSize(width: width, height: height))
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AppDelegate.videoPlayVC.playVideo(withURL: viewModel.datas[indexPath.row].videoURL)
        AppDelegate.homeNavigationVC.pushViewController(AppDelegate.videoPlayVC, animated: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y == 0 && canRefresh {
            canRefresh = false
            viewModel.datas.removeAll()
            weak var weakRef = self
            viewModel.fetchData(handle: { ()->Void in
                weakRef?.collectionView!.reloadData()
            })
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
        let cellBottom = max(freshCellBottom[0],freshCellBottom[1]) - (scrollView.frame.height - AppDelegate.tabHeight)
      
        if scrollView.contentOffset.y > cellBottom {
            scrollView.setContentOffset(CGPoint(x: 0, y: cellBottom), animated: false)
            
            // 拉取新的数据，实现向下滚动无限刷新
            weak var weakRef = self
            viewModel.fetchData(handle: { ()->Void in
                weakRef?.collectionView!.reloadData()
            })
        }
    }
    
    
}
