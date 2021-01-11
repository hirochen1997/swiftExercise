//
//  HomeShortVideoViewCell.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/7.
//

import UIKit

class HomeShortVideoViewCell: UICollectionViewCell {
    let videoFrameImg = UIImageView()
    let info = UILabel()
    let userName = UILabel()
    let userImg = UIImageView()
    let title = UILabel()
    
    let kScreenWidth = UIScreen.main.bounds.width
    let kScreenHeight = UIScreen.main.bounds.height
    
    static let minimumInteritemSpacing: CGFloat = 5
    static let minimumLineSpacing: CGFloat = 5
    static let sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCell() {
        initSetUp()
        
        self.backgroundColor = UIColor.gray
        
        self.addSubview(videoFrameImg)
        self.addSubview(title)
        self.addSubview(userImg)
        self.addSubview(userName)
        self.addSubview(info)
        

    }
    
    // 因为cell的重用机制，为了避免从队列中取出来的cell不受到之前设置的影响，重新初始化设置
    func initSetUp() {
        videoFrameImg.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: kScreenWidth*0.6)
        videoFrameImg.backgroundColor = UIColor.red
        
        title.frame = CGRect(x: 0, y: videoFrameImg.frame.origin.y+videoFrameImg.frame.height+3, width: videoFrameImg.frame.width, height: 40)
        title.numberOfLines = 0 // 自动换行
        title.tintColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 15)
        title.text = ""
        
        userImg.frame = CGRect(x: 0, y: videoFrameImg.frame.origin.y+videoFrameImg.frame.height+3, width: kScreenWidth/15, height: kScreenWidth/15)
        userImg.backgroundColor = UIColor.green
        userImg.layer.masksToBounds = true // 设置圆角
        userImg.layer.cornerRadius = userImg.frame.width/2
        
        userName.frame = CGRect(x: userImg.frame.origin.x + userImg.frame.width + 5, y: userImg.frame.origin.y, width: 60, height: 30)
        userName.tintColor = UIColor.black
        userName.text = "取个什么名字"
        userName.font = UIFont.systemFont(ofSize: 8)
        
        info.frame = CGRect(x: self.frame.width - 70, y: userName.frame.origin.y, width: 60, height: 30)
        info.text = "空"
        info.tintColor = UIColor.black
        info.font = UIFont.systemFont(ofSize: 8)
        info.textAlignment = .right
    }
    
}


