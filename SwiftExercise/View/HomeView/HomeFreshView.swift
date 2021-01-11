//
//  HomeFreshView.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeFreshView: UIView {
    let viewModel = HomeFreshViewModel()
    
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
        
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white
        //collectionView.bounces = false

      
        self.addSubview(collectionView)

    }
}
