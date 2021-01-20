//
//  HomeViewCell.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/7.
//

import UIKit

class HomeFollowViewCell: UICollectionViewCell {
    let userName = UILabel()
    let fansCount = UILabel()
    let followButton = UIButton()
    let userImg = UIImageView()
    var showList: [UIImageView] = []
    
    var viewModel: HomeFollowViewModel!
    var cellIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCell() {
        initSetUp()
        
        self.addSubview(userImg)
        self.addSubview(userName)
        self.addSubview(fansCount)
        self.addSubview(followButton)
        for i in 0..<showList.count {
            self.addSubview(showList[i])
        }
        self.backgroundColor = UIColor.lightGray
    }
    
    // 用于cell复用时先初始化避免旧的数据影响
    func initSetUp() {
        userImg.frame = CGRect(x: 10, y: 5, width: kScreenWidth/6, height: kScreenWidth/6)
        userImg.backgroundColor = UIColor.green
        userImg.layer.masksToBounds = true // 设置遮罩
        userImg.layer.cornerRadius = userImg.frame.width/2 // 设置半径，显示圆形
        
        userName.frame = CGRect(x: userImg.frame.origin.x + userImg.frame.width + 10, y: userImg.frame.origin.y, width: kScreenWidth/2, height: userImg.frame.height)
        userName.text = "取个什么名字"
        userName.tintColor = UIColor.black
        
        fansCount.frame = CGRect(x: userName.frame.origin.x, y: userName.frame.origin.y + 30, width: kScreenWidth/2, height: userName.frame.height)
        fansCount.text = "粉丝数：" + "999"
        fansCount.tintColor = UIColor.black
        fansCount.font = UIFont.systemFont(ofSize: 12)
        
        followButton.frame = CGRect(x: kScreenWidth - 70, y: fansCount.frame.origin.y + 5, width: 70, height: 30)
        
        followButton.setTitle("关注", for: .normal)
        followButton.setTitle("已关注", for: .selected)
        followButton.backgroundColor = UIColor.orange
        followButton.addTarget(self, action: #selector(changeButtonState), for: .touchUpInside)
        
        for i in 0..<4 {
            let t_img = UIImageView(frame: CGRect(x: (kScreenWidth-50)/4*CGFloat(i)+CGFloat(i+1)*10, y: userImg.frame.origin.y+userImg.frame.height+5, width: (kScreenWidth-50)/4, height: (kScreenWidth-50)/4))
            t_img.backgroundColor = UIColor.systemPink
            showList.append(t_img)
            
        }
    }
    
    @objc func changeButtonState() {
        weak var weakRef = self
        if viewModel.datas[cellIndex].isFollow {
            viewModel.uploadData(index: cellIndex, value: "false", handle: { ()->Void in
                weakRef?.viewModel.datas[weakRef!.cellIndex].isFollow = false
                weakRef?.followButton.isSelected = false
                weakRef?.followButton.backgroundColor = UIColor.orange
            })
            
        }
        else {
            viewModel.uploadData(index: cellIndex, value: "true", handle: {()->Void in
                weakRef?.viewModel.datas[weakRef!.cellIndex].isFollow = true
                weakRef?.followButton.isSelected = true
                weakRef?.followButton.backgroundColor = UIColor.gray
            })
        }
    }
    
    
}
