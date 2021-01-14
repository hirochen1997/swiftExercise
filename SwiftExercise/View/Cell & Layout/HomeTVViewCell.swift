//
//  HomeTVViewCell.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/12.
//

import UIKit
import AVKit


class HomeTVViewCell: UICollectionViewCell {
    let userName = UILabel()
    let playerLayer = AVPlayerLayer()
    let progressSlider = UISlider()
    let playButton = UIButton()
    let progressTime = UILabel()
    let backgroundImage = UIImageView()
    
    var isPlaying = true
    var timeObserver: Any?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCell() {
        userName.frame = CGRect(x: 10, y: kScreenHeight-2*buttonHeight-AppDelegate.tabHeight-50, width: 60, height: 40)
        userName.textColor = UIColor.white
        userName.font = UIFont.systemFont(ofSize: 15)
        userName.text = "名字"
        
        playerLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-2*buttonHeight-AppDelegate.tabHeight)
        
        
        progressSlider.frame = CGRect(x: 50, y: kScreenHeight/2+30, width: kScreenWidth-120, height: 30)
        progressSlider.maximumValue = 1
        progressSlider.minimumValue = 0
        
        playButton.frame = CGRect(x: 5, y: progressSlider.frame.origin.y, width: progressSlider.frame.height, height: progressSlider.frame.height)
        playButton.setImage(UIImage(named: "stop"), for: .normal)
        playButton.addTarget(self, action: #selector(changePlayStatus), for: .touchDown)
      
        
        progressTime.frame = CGRect(x: kScreenWidth-80, y: progressSlider.frame.origin.y, width: 70, height: progressSlider.frame.height)
        progressTime.textColor = UIColor.white
        progressTime.font = UIFont.systemFont(ofSize: 12)
        progressTime.text = "00:00:00"
        progressTime.textAlignment = .right
        
        
        
        self.backgroundColor = UIColor.black
        self.layer.addSublayer(playerLayer)
        self.addSubview(userName)
        self.addSubview(progressSlider)
        self.addSubview(playButton)
        self.addSubview(progressTime)
    }
    
    func setTV(tvURL: String) {
        // 先去掉原来的tvPlayer的observer
        if timeObserver != nil {
            playerLayer.player?.removeTimeObserver(timeObserver!)
        }
        
        let videoURL = URL(string: tvURL)!
        let tvPlayer = AVPlayer(url: videoURL)
        progressTime.text = CMTimeGetSeconds(tvPlayer.currentItem!.duration) >= 3600 ? "00:00:00" : "00:00"
        
        weak var weakRef = self // 防止block访问成员变量时捕获self引起循环引用
        timeObserver = tvPlayer.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: CMTimeScale(NSEC_PER_SEC)), queue: nil, using: {(cmtime) in
            let playTime = Int(cmtime.seconds)
            let totalTime = CMTimeGetSeconds(tvPlayer.currentItem!.duration)
            let progress = Double(playTime) / totalTime
            
            // 修改进度条&时间显示
            weakRef!.progressSlider.value = Float(progress)
            let hour = (playTime / 3600 < 10 ? "0" : "") + String(playTime/3600)
            let minute = (playTime % 3600 / 60 < 10 ? "0" : "") + String(playTime%3600/60)
            let second = (playTime % 3600 % 60 < 10 ? "0" : "") + String(playTime%3600%60)
            
            if totalTime >= 3600 {
                // 超过1小时的采用时分秒
                weakRef!.progressTime.text = hour + ":" + minute + ":" + second
                
            } else {
                // 1小时以内的采用分秒
                weakRef!.progressTime.text = minute + ":" + second
            }
            

            if (progress == 1.0) {
                //播放百分比为1表示已经播放完毕
                print("播放完成")
                //处理播放完成之后的操作
                
            }
        })
        
        playerLayer.player = tvPlayer
        
    }
    
    @objc func changePlayStatus() {
        if isPlaying {
            playerLayer.player?.pause()
            playButton.setImage(UIImage(named: "play.jpg"), for: .normal)
            isPlaying = false
        } else {
            playerLayer.player?.play()
            playButton.setImage(UIImage(named: "stop.jpg"), for: .normal)
            isPlaying = true
        }
    }
    
    
    
}
