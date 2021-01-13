//
//  HomeTVViewCell.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/12.
//

import UIKit
import AVKit


class HomeTVViewCell: UITableViewCell {
    let userName = UILabel()
    let playerLayer = AVPlayerLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCell() {
        userName.frame = CGRect(x: 10, y: kScreenHeight-2*buttonHeight-AppDelegate.tabHeight-50, width: 60, height: 40)
        userName.tintColor = UIColor.black
        userName.font = UIFont.systemFont(ofSize: 15)
        userName.text = "名字"
        
        playerLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-2*buttonHeight-AppDelegate.tabHeight)
        
        self.layer.addSublayer(playerLayer)
        self.addSubview(userName)
        
    }
    
    func setTV(tvURL: String) {
        let videoURL = URL(string: tvURL)!
        let tvPlayer = AVPlayer(url: videoURL)
        playerLayer.player = tvPlayer
        
    }
}
