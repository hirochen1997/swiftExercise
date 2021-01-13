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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initShortVideoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initShortVideoView() {
        let layout = CustomCollectionViewLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = HomeShortVideoViewCell.minimumLineSpacing
        layout.minimumInteritemSpacing = HomeShortVideoViewCell.minimumInteritemSpacing
        layout.sectionInset = HomeShortVideoViewCell.sectionInset
        layout.estimatedItemSize = CGSize(width: (kScreenWidth-layout.minimumInteritemSpacing-layout.sectionInset.left-layout.sectionInset.right)/2, height: kScreenWidth*0.8) // itemSize会固定，estimatedItemSize可以动态调整
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 2*buttonHeight), collectionViewLayout: layout)
        collectionView.register(HomeShortVideoViewCell.self, forCellWithReuseIdentifier: "ShortVideoCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white
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
        
        // 获得title中字符串的高度
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        var textHeight = cell.title.text?.boundingRect(with: CGSize(width: cell.title.frame.width, height: cell.title.frame.height), options: option, attributes: attributes, context: nil).height
      
        if cell.title.text! == "" {
            // 空字符串也会计算高度，这里需要置为0
            textHeight = 0
        }
        
        // 根据title的字符串高度，部分控件需要下移
        cell.userImg.frame = CGRect(x: cell.userImg.frame.origin.x, y: cell.userImg.frame.origin.y + textHeight!, width: cell.userImg.frame.width, height: cell.userImg.frame.height)
        cell.userName.frame = CGRect(x: cell.userName.frame.origin.x, y: cell.userName.frame.origin.y + textHeight!, width: cell.userName.frame.width, height: cell.userName.frame.height)
        cell.info.frame = CGRect(x: cell.info.frame.origin.x, y: cell.info.frame.origin.y+textHeight!, width: cell.info.frame.width, height: cell.info.frame.height)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        var textHeight = viewModel.datas[indexPath.row].title.boundingRect(with: CGSize(width: (kScreenWidth-HomeShortVideoViewCell.minimumInteritemSpacing-HomeShortVideoViewCell.sectionInset.left-HomeShortVideoViewCell.sectionInset.right)/2, height: 40), options: option, attributes: attributes, context: nil).height

        // 空字符串也会有高度，需要置为0
        if viewModel.datas[indexPath.row].title == "" {
            textHeight = 0
        }
        
        let width = (kScreenWidth-HomeShortVideoViewCell.minimumInteritemSpacing-HomeShortVideoViewCell.sectionInset.left-HomeShortVideoViewCell.sectionInset.right)/2
        let height = kScreenWidth*0.7+textHeight
        
        if indexPath.row == 0 {
            freshCellBottom[0] = 0
            freshCellBottom[1] = 0
        }
        
        freshCellBottom[indexPath.row % 2] += height + (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
        
        if indexPath.row == viewModel.datas.count - 2 || indexPath.row == viewModel.datas.count - 1 {
            freshCellBottom[indexPath.row % 2] -= (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
        }
        
        // 设置当前cell的layout
        (collectionViewLayout as! CustomCollectionViewLayout).setLayoutAttributesForItem(at: indexPath, size: CGSize(width: width, height: height))
        
        return CGSize(width: width, height: height)
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
        let cellBottom = max(freshCellBottom[0],freshCellBottom[1]) - (scrollView.frame.height - AppDelegate.tabHeight)
      
        if scrollView.contentOffset.y > cellBottom {
            scrollView.setContentOffset(CGPoint(x: 0, y: cellBottom), animated: false)
            
            // 拉取新的数据，实现向下滚动无限刷新
            viewModel.fetchData()
            (scrollView as! UICollectionView).reloadData()
            (scrollView as! UICollectionView).collectionViewLayout.invalidateLayout()
        }
    }
}
