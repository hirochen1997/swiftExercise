//
//  HomeViewController.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/5.
//
import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let kScreenWidth = UIScreen.main.bounds.width
    let kScreenHeight = UIScreen.main.bounds.height
    
    let titles = ["关注", "新鲜", "推荐", "避风TV"]
    let buttonHeight = CGFloat(50)
    
    let contentScrollView = UIScrollView()
    let titleScroll = UIImageView() // 自己定义一个标题栏的滚动条
    
    var ButtonList: [UIButton] = []
    var selectedButton = 0, lastSelecetedButton = 0
    var infoList: [String] = []
    var canFollowViewRefresh = false
    var canFreshViewRefresh = false
    var canRecommendViewRefresh = false
    var canTVViewRefresh = false

    var freshCellBottom: [CGFloat] = [0,0]
    var recommendCellBottom: [CGFloat] = [0,0]
    
    // 数据存储
    var homeFollowViewDatas: [HomeFollowViewData] = []
    var homeFreshViewDatas: [HomeShortVideoViewData] = []
    var homeRecommendViewDatas: [HomeShortVideoViewData] = []
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        print("首页!!!")
        
        // 设置滑动标题
        setScrollTitle()
        
        // 设置滑动内容
        setScrollContent()
    
    }
    
    func setScrollTitle() {
        titleScroll.frame = CGRect(x: 0, y: buttonHeight*1.8, width: kScreenWidth/4, height: buttonHeight*0.03)
        titleScroll.backgroundColor = UIColor.black
        self.view.addSubview(titleScroll)
        
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
        
        self.view.addSubview(followTitle)
        self.view.addSubview(freshTitle)
        self.view.addSubview(recommendTitle)
        self.view.addSubview(TVTitle)

    }
    
    func setScrollContent() {
        // 定义每一个页面
        initFollowView()
        initShortVideoView(kind: 0)
        initShortVideoView(kind: 1)
        
        
        let TVView = UIView(frame: CGRect(x: kScreenWidth*3, y: 0, width: kScreenWidth, height: kScreenHeight - 2*buttonHeight))
        TVView.backgroundColor = UIColor.purple
        
        // 设置scrollView
        contentScrollView.frame = CGRect(x: 0, y: buttonHeight * 2, width: kScreenWidth, height: kScreenHeight - 2*buttonHeight)
        contentScrollView.isScrollEnabled = true
        contentScrollView.isPagingEnabled = true // 设置为true才有翻页效果，不然一直滑
        contentScrollView.showsHorizontalScrollIndicator = true
        contentScrollView.tag = -1
        contentScrollView.delegate = self
        

        contentScrollView.addSubview(TVView)
        contentScrollView.contentSize = CGSize(width: 4*kScreenWidth, height: 0)
        self.view.addSubview(contentScrollView)
    }
    
    @objc func syncTitleAndContent(button: UIButton) {
        contentScrollView.setContentOffset(CGPoint(x: CGFloat(button.tag) * kScreenWidth, y: 0), animated: false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView is UICollectionView && scrollView.contentOffset.y == 0 && canFollowViewRefresh {
            canFollowViewRefresh = false
            (scrollView as! UICollectionView).layoutIfNeeded()
            (scrollView as! UICollectionView).reloadData()
            print("reload")
        }
        
    }
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView is UICollectionView {
            // 顶部上拉刷新
            if scrollView.contentOffset.y < 0 {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                canFollowViewRefresh = true
            }
            else {
                canFollowViewRefresh = false
            }
            
            var cellBottom: CGFloat = 0
            switch scrollView.tag {
            case 0:
                cellBottom = scrollView.contentSize.height - (scrollView.frame.height - AppDelegate.tabHeight)
            case 1:
                //下滑只能到最后一行的cell刚好整个完全显示这里获取的tabHeight才是准确的，必须要用view的高度减去tabHeight才是view可视部分的高度
                cellBottom = max(freshCellBottom[0],freshCellBottom[1]) - (scrollView.frame.height - AppDelegate.tabHeight)
            case 2:
                cellBottom = max(recommendCellBottom[0],recommendCellBottom[1]) - (scrollView.frame.height - AppDelegate.tabHeight)
            default:
                cellBottom = 0
            }

            if scrollView.contentOffset.y > cellBottom {
                scrollView.setContentOffset(CGPoint(x: 0, y: cellBottom), animated: false)
            }

        }
        else {
            // 将当前内容scrollView与title中的button同步
            if scrollView.tag == -1 {
                // 说明滑动的是内容scrollView
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
        }
        
    }
    
    func initFollowView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: kScreenWidth, height: kScreenWidth/2)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 2*buttonHeight),collectionViewLayout: layout)
        collectionView.register(HomeFollowViewCell.self, forCellWithReuseIdentifier: "FollowCell") // 注册自定义的cell，从而可以在队列里复用
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white
        collectionView.tag = 0
        
        contentScrollView.addSubview(collectionView)
        
        // 获取初始数据
        let data = FetchData.fetchData(kind: 0) as! [HomeFollowViewData]
        homeFollowViewDatas.append(contentsOf: data)
    }
    
    func initShortVideoView(kind: Int) {
        let layout = CustomCollectionViewLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.estimatedItemSize = CGSize(width: (kScreenWidth-40)/2, height: kScreenWidth*0.8) // itemSize会固定，estimatedItemSize可以动态调整
        let collectionView = UICollectionView(frame: CGRect(x: kScreenWidth*CGFloat(kind+1), y: 0, width: kScreenWidth, height: kScreenHeight - 2*buttonHeight), collectionViewLayout: layout)
        collectionView.register(HomeShortVideoViewCell.self, forCellWithReuseIdentifier: "ShortVideoCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white
        //collectionView.bounces = false
        
        if kind == 0 {
            // 新鲜模块
            collectionView.tag = 1
            
            // 获取初始数据
            let data = FetchData.fetchData(kind: collectionView.tag) as! [HomeShortVideoViewData]
            homeFreshViewDatas.append(contentsOf: data)
        }
        else {
            // 推荐模块
            collectionView.tag = 2
            
            // 获取初始数据
            let data = FetchData.fetchData(kind: collectionView.tag) as! [HomeShortVideoViewData]
            homeRecommendViewDatas.append(contentsOf: data)
        }
        
        contentScrollView.addSubview(collectionView)

    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowCell", for: indexPath) as! HomeFollowViewCell
            
            // 将数据填充到cell
            let t_data = homeFollowViewDatas[indexPath.row]
            cell.userName.text = t_data.userName
            cell.fansCount.text = t_data.fansCount
            cell.isFollow = t_data.isFollow
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortVideoCell", for: indexPath) as! HomeShortVideoViewCell

            // 初始化cell的设置，避免复用的cell受到之前设置的影响
            cell.initSetUp()
            
            // 将数据填充到cell
            let t_data = homeFreshViewDatas[indexPath.row]
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
        
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortVideoCell", for: indexPath) as! HomeShortVideoViewCell
            
            // 初始化cell的设置，避免复用的cell受到之前设置的影响
            cell.initSetUp()
            
            // 将数据填充到cell
            let t_data = homeRecommendViewDatas[indexPath.row]
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
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 获得title中字符串的高度
        switch collectionView.tag {
        case 0:
            return CGSize(width: kScreenWidth, height: kScreenWidth/2)
            
        case 1:
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            var textHeight = homeFreshViewDatas[indexPath.row].title.boundingRect(with: CGSize(width: (kScreenWidth-40)/2, height: 40), options: option, attributes: attributes, context: nil).height

            // 空字符串也会有高度，需要置为0
            if homeFreshViewDatas[indexPath.row].title == "" {
                textHeight = 0
            }
            
            let width = (kScreenWidth-40)/2
            let height = kScreenWidth*0.7+textHeight
            
            if indexPath.row == 0 {
                freshCellBottom[0] = 0
                freshCellBottom[1] = 0
            }
            
            freshCellBottom[indexPath.row % 2] += height + (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
            
            if indexPath.row == homeFreshViewDatas.count - 2 || indexPath.row == homeFreshViewDatas.count - 1 {
                freshCellBottom[indexPath.row % 2] -= (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
            }
            
            return CGSize(width: width, height: height)
            
        case 2:
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            var textHeight = homeRecommendViewDatas[indexPath.row].title.boundingRect(with: CGSize(width: (kScreenWidth-40)/2, height: 40), options: option, attributes: attributes, context: nil).height
            
            // 空字符串也会有高度，需要置为0
            if homeRecommendViewDatas[indexPath.row].title == "" {
                textHeight = 0
            }
            
            let width = (kScreenWidth-40)/2
            let height = kScreenWidth*0.7+textHeight
            
            if indexPath.row == 0 {
                recommendCellBottom[0] = 0
                recommendCellBottom[1] = 0
            }
            
            recommendCellBottom[indexPath.row % 2] += height + (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
            
            if indexPath.row == homeRecommendViewDatas.count - 2 || indexPath.row == homeRecommendViewDatas.count - 1 {
                recommendCellBottom[indexPath.row % 2] -= (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
            }
            
            return CGSize(width: width, height: height)
            
        default:
            return CGSize(width: 100, height: 100)
        }

    }

    
}


