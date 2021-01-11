//
//  HomeFollowView.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeFollowView: UIView {
    let viewModel = HomeFollowViewModel()
    
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
        
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white

        self.addSubview(collectionView)
    }
    
}
