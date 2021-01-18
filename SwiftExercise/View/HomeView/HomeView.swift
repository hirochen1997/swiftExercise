//
//  HomeView.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeView: UIView, UIScrollViewDelegate {
    let titles = ["关注", "新鲜", "推荐", "避风TV"]
    
    let contentScrollView = UIScrollView()
    let titleScroll = UIImageView() // 自己定义一个标题栏的滚动条
    let homeFollowView = HomeFollowView()
    let homeFreshView = HomeFreshView()
    let homeRecommendView = HomeRecommendView()
    let homeTVView = HomeTVView()
    
    var ButtonList: [UIButton] = []
    var selectedButton = 0, lastSelecetedButton = 0
    var infoList: [String] = []
    var lastModule = 3 // 滑动前的模块序号
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 设置滑动标题
        setScrollTitle()
        
        // 设置滑动内容
        setScrollContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScrollTitle() {
        titleScroll.frame = CGRect(x: 0, y: buttonHeight*1.8, width: kScreenWidth/4, height: buttonHeight*0.03)
        titleScroll.backgroundColor = UIColor.black
        self.addSubview(titleScroll)
        
        let followTitle = UIButton(frame: CGRect(x: 0, y: buttonHeight, width: kScreenWidth/4, height: buttonHeight))
        followTitle.setTitle(titles[0], for: .normal)
        followTitle.setTitleColor(.gray, for: .normal)
        followTitle.setTitleColor(.black, for: .selected)
        followTitle.setTitleShadowColor(.black, for: .selected)
        followTitle.setTitleShadowColor(.none, for: .normal)
        followTitle.tag = 0
        ButtonList.append(followTitle)
        
        let freshTitle = UIButton(frame: CGRect(x: kScreenWidth/4, y: buttonHeight, width: kScreenWidth/4, height: buttonHeight))
        freshTitle.setTitle(titles[1], for: .normal)
        freshTitle.setTitleColor(.gray, for: .normal)
        freshTitle.setTitleColor(.black, for: .selected)
        freshTitle.setTitleShadowColor(.black, for: .selected)
        freshTitle.setTitleShadowColor(.none, for: .normal)
        freshTitle.tag = 1
        ButtonList.append(freshTitle)
        
        let recommendTitle = UIButton(frame: CGRect(x: kScreenWidth/2, y: buttonHeight, width: kScreenWidth/4, height: buttonHeight))
        recommendTitle.setTitle(titles[2], for: .normal)
        recommendTitle.setTitleColor(.gray, for: .normal)
        recommendTitle.setTitleColor(.black, for: .selected)
        recommendTitle.setTitleShadowColor(.black, for: .selected)
        recommendTitle.setTitleShadowColor(.none, for: .normal)
        recommendTitle.tag = 2
        ButtonList.append(recommendTitle)
        
        let TVTitle = UIButton(frame: CGRect(x: kScreenWidth/4*3, y: buttonHeight, width: kScreenWidth/4, height: buttonHeight))
        TVTitle.setTitle(titles[3], for: .normal)
        TVTitle.setTitleColor(.gray, for: .normal)
        TVTitle.setTitleColor(.black, for: .selected)
        TVTitle.setTitleShadowColor(.black, for: .selected)
        TVTitle.setTitleShadowColor(.none, for: .normal)
        TVTitle.tag = 3
        ButtonList.append(TVTitle)
        
        // 初始化默认标题为选中
        ButtonList[selectedButton].isSelected = true
        
        // 为每一个标题按钮绑定滑动内容
        for i in 0..<ButtonList.count {
            ButtonList[i].addTarget(self, action: #selector(syncTitleAndContent), for: .touchDown)
        }
        
        self.addSubview(followTitle)
        self.addSubview(freshTitle)
        self.addSubview(recommendTitle)
        self.addSubview(TVTitle)

    }
    
    func setScrollContent() {
        // 设置scrollView
        contentScrollView.frame = CGRect(x: 0, y: buttonHeight * 2, width: kScreenWidth, height: kScreenHeight - 2*buttonHeight)
        contentScrollView.isScrollEnabled = true
        contentScrollView.isPagingEnabled = true // 设置为true才有翻页效果，不然一直滑
        contentScrollView.showsHorizontalScrollIndicator = true
        contentScrollView.bounces = false
        
        contentScrollView.delegate = self
        
        // 定义每一个页面
        homeFollowView.frame = CGRect(x: 0, y: 0, width: contentScrollView.frame.width, height: contentScrollView.frame.height)
        homeFreshView.frame = CGRect(x: kScreenWidth, y: 0, width: contentScrollView.frame.width, height: contentScrollView.frame.height)
        homeRecommendView.frame = CGRect(x: kScreenWidth*2, y: 0, width: contentScrollView.frame.width, height: contentScrollView.frame.height)
        homeTVView.frame = CGRect(x: kScreenWidth*3, y: 0, width: contentScrollView.frame.width, height: contentScrollView.frame.height)

        contentScrollView.addSubview(homeFollowView)
        contentScrollView.addSubview(homeFreshView)
        contentScrollView.addSubview(homeRecommendView)
        contentScrollView.addSubview(homeTVView)
        contentScrollView.contentSize = CGSize(width: 4*kScreenWidth, height: 0)
        self.addSubview(contentScrollView)
        
        // 初始页面设置为避风TV
        contentScrollView.setContentOffset(homeTVView.frame.origin, animated: false)
    }
    
    @objc func syncTitleAndContent(button: UIButton) {
        if contentScrollView.contentOffset.x == homeTVView.frame.origin.x {
            // 跳转前是避风TV模块的话，就关闭正在播放的tv
            homeTVView.stopTV()
        }
        
        contentScrollView.setContentOffset(CGPoint(x: CGFloat(button.tag) * kScreenWidth, y: 0), animated: false)
        
        if contentScrollView.contentOffset.x == homeTVView.frame.origin.x {
            // 跳转后是避风TV模块的话，就重新播放tv
            homeTVView.startTV()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 将当前内容scrollView与title中的button同步
        titleScroll.frame.origin = CGPoint(x: scrollView.contentOffset.x/4, y: buttonHeight*1.9)
        let t_value = scrollView.contentOffset.x / kScreenWidth
        
        ButtonList[lastSelecetedButton].isSelected = false
        if t_value < 0.5 {
            selectedButton = 0
        }
        else if t_value >= 0.5 && t_value < 1.5 {
            selectedButton = 1
        }
        else if t_value >= 1.5 && t_value < 2.5 {
            selectedButton = 2
        }
        else if t_value >= 2.5 {
            selectedButton = 3
        }
        lastSelecetedButton = selectedButton
        ButtonList[selectedButton].isSelected = true
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x < homeTVView.frame.origin.x {
            // 当前页面不是避风tv模块时，暂停tv里的视频
            homeTVView.stopTV()
            
        } else if lastModule < 3 {
            // 当前页面是避风tv模块时，播放tv里的视频
            homeTVView.startTV()
        }
        lastModule = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
    }
    
    
}
