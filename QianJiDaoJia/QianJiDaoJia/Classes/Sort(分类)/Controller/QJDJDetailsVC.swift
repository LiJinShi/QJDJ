//
//  QJDJDetailsVC.swift
//  QianJiDaoJia
//
//  Created by zengqiang on 16/6/18.
//  Copyright © 2016年 LJS. All rights reserved.
//  分类点击进去的详情界面

import UIKit
import SVProgressHUD
import MJRefresh
class QJDJDetailsVC: UIViewController {
   private var detailsModelArray: [QJDJDetailsModel]?
   private var detailsCollectionView_1: UICollectionView?
   private var detailsCollectionView_2: UICollectionView?
   private var topView: QJDJDetailTopView?
   private var noDataView: QJDJNoDetailsModelView?
   private var navBtnView: QJDJDetailsNavRightItem?
   private let screenWidth = UIScreen.mainScreen().bounds.width
   private let screenHeight = UIScreen.mainScreen().bounds.height
   private let cellHeight = 90
   private let topViewHeight: CGFloat = 30
   private var placeHolderView: UIView?
   private var navBarHidden: Bool = false
   private var navBarHeight: CGFloat {
        return navBarHidden == true ? 20 : 64
    }
   private let margin: CGFloat = 5
    private var pageIndex = 2
    // 绑定cell标识
   private let firstCellID = "firstCell"
   private let secondCellID = "secondCell"
    private let backColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    // url中的参数
   private var urlSTR: String = ""
    var categoryID: Int = 0 {
        willSet(newID) {
            let newUrl = "http://bmworld.cn:1234/Mobile/V1.asmx/GetCategoryGoodsList?StationId=3&CategoryId="+"\(newID)"+"&KeyWord=&pageSize=20&pageIndex=1&SortFlag=0&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
            urlSTR = newUrl
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = backColor
        setUpUI()
        loadData(urlSTR)
        setUpNavRightBlock()
        setUpBlock()
        setUpHeaderRefreshView()
        setUpFooterRefreshView()
    }
    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
}
    //MARK: - 请求数据
extension QJDJDetailsVC {
    
    func loadNewData() {
        let urlStr = urlSTR
        loadData(urlStr)
    }
    // 刚跳转过来时请求的数据
    func loadData(urlStr: String) {
        SVProgressHUD.showWithStatus("正在加载数据,请稍后...")
        NetworkingTool().request(RequestType.requestTypeGet, URLString: urlStr, Parameter: nil) { (responseData, error) in
                        // 请求完成时结束刷新
            self.detailsCollectionView_1?.mj_header.endRefreshing()
            self.detailsCollectionView_2?.mj_header.endRefreshing()
            guard let data = responseData else {
                SVProgressHUD.dismiss()
                return
            }
            guard let dictArray: [[String: AnyObject]] = data["DataList"] as? [[String: AnyObject]] else {
                return
            }
            var tempModelArray = [QJDJDetailsModel]()
            for dict in dictArray {
                let model = QJDJDetailsModel(dict: dict)
                tempModelArray.append(model)
            }
            self.detailsModelArray = tempModelArray
            if self.detailsModelArray?.count == 0 {
                self.noDataView?.hidden = false
            }
            self.detailsCollectionView_1?.reloadData()
            self.hiddenFooter(dictArray.count)
            SVProgressHUD.dismiss()
        }
    }
    func loadNewMoreData() {
        let url = "http://bmworld.cn:1234/Mobile/V1.asmx/GetCategoryGoodsList?StationId=3&CategoryId="+"\(categoryID)"+"&KeyWord=&pageSize=20&pageIndex="+"\(pageIndex)"+"&SortFlag=0&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
        loadMoreData(url)
    }
    // 上下拉刷新,加载跟多数据
    func loadMoreData(urlStr: String) {
        SVProgressHUD.showWithStatus("正在加载数据,请稍后...")
        NetworkingTool().request(RequestType.requestTypeGet, URLString: urlStr, Parameter: nil) { (responseData, error) in
            guard let data = responseData else {
                SVProgressHUD.dismiss()
                return
            }
            guard let dictArray: [[String: AnyObject]] = data["DataList"] as? [[String: AnyObject]] else {
                return
            }
            // 请求完成时结束刷新
            self.detailsCollectionView_1?.mj_footer.endRefreshing()
            self.detailsCollectionView_2?.mj_footer.endRefreshing()
            var tempModelArray = [QJDJDetailsModel]()
            for dict in dictArray {
                let model = QJDJDetailsModel(dict: dict)
                tempModelArray.append(model)
            }
           self.detailsModelArray = self.detailsModelArray! + tempModelArray
            if self.detailsModelArray?.count == 0 {
                self.noDataView?.hidden = false
            }
            self.detailsCollectionView_1?.reloadData()
            self.detailsCollectionView_2?.reloadData()
            if dictArray.count > 0 {
                self.pageIndex += 1
            }
            self.hiddenFooter(dictArray.count)
            SVProgressHUD.dismiss()
        }
    }
}
    //MARK: - 界面
extension QJDJDetailsVC {
    func setUpUI() {
        // 添加顶部的View
        let topView = QJDJDetailTopView.topView()
        topView.frame = CGRect(x: 0, y: navBarHeight, width: screenWidth, height: topViewHeight)
        self.topView = topView
        view.addSubview(topView)
        // 添加collectionView
        // 第一种样式的collectionView
        let bottomView = UICollectionView(frame: CGRectMake(0, navBarHeight + topViewHeight, screenWidth, screenHeight - navBarHeight - topViewHeight), collectionViewLayout: QJDJDetailFlowLayout_1())
        bottomView.backgroundColor = backColor
        // 第二种样式的collectionView
        let placeHolderView = UIView(frame: CGRectMake(margin, navBarHeight + topViewHeight, screenWidth - 2 * margin, screenHeight - navBarHeight - topViewHeight))
        placeHolderView.backgroundColor = backColor
        let bottomView_2 = UICollectionView(frame: placeHolderView.bounds, collectionViewLayout: QJDJQJDJDetailFlowLayout_2())
        bottomView_2.backgroundColor = backColor
        placeHolderView.addSubview(bottomView_2)
        self.placeHolderView = placeHolderView
        bottomView.dataSource = self
        bottomView.delegate = self
        bottomView_2.dataSource = self
        bottomView_2.delegate = self
        self.detailsCollectionView_1 = bottomView
        self.detailsCollectionView_2 = bottomView_2
        // 注册cell
        bottomView.registerNib(UINib.init(nibName: "QJDJDetailsCollectionCell", bundle: nil), forCellWithReuseIdentifier: firstCellID)
        bottomView.showsVerticalScrollIndicator = false
        view.addSubview(bottomView)
        // 没有数据展示的view
        let noDataView = QJDJNoDetailsModelView()
        noDataView.backgroundColor = UIColor.whiteColor()
        noDataView.frame = CGRectMake(0, navBarHeight + topViewHeight, screenWidth, screenHeight - navBarHeight - topViewHeight)
        noDataView.hidden = true
        self.noDataView = noDataView
        view.addSubview(noDataView)
        bottomView_2.registerNib(UINib.init(nibName: "QJDJCollectionCell_2", bundle: nil), forCellWithReuseIdentifier: secondCellID)
        bottomView.showsVerticalScrollIndicator = false
        // 添加导航条右边按钮
        let buttonView = QJDJDetailsNavRightItem()
        buttonView.bounds = buttonView.btn.bounds
        self.navBtnView = buttonView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonView)
    }
}
    //MARK: - 添加上下拉刷新
extension QJDJDetailsVC {
    // 下拉刷新
    func setUpHeaderRefreshView() {
        let header1 = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.loadNewData))
        let header2 = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.loadNewData))
        header1.automaticallyChangeAlpha = true
        header2.automaticallyChangeAlpha = true
        header1.setTitle("正在刷新请稍后...", forState: .Refreshing)
        header2.setTitle("正在刷新请稍后...", forState: .Refreshing)
        detailsCollectionView_1?.mj_header = header1
        detailsCollectionView_2?.mj_header = header2
        // 使用MJRefresh记得在请求成功的时候结束刷新
    }
    // 上拉加载
    func setUpFooterRefreshView() {
        let footer1 = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadNewMoreData))
        //footer1.backgroundColor = UIColor.whiteColor()
        let footer2 = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadNewMoreData))
        footer1.setTitle("正在加载,请稍后...", forState: .Refreshing)
        footer2.setTitle("正在加载,请稍后...", forState: .Refreshing)
        //footer1.stateLabel.hidden = true
        footer1.automaticallyHidden = true
        footer2.automaticallyHidden = true
        detailsCollectionView_1?.mj_footer = footer1
        detailsCollectionView_2?.mj_footer = footer2
        
    }
}

    //MARK: collectionView的代理方法和数据源方法
extension QJDJDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate {

    // cell个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = detailsModelArray?.count else {
            
            return 0
        }
        return count
    }
    // 返回cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == detailsCollectionView_1 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(firstCellID, forIndexPath: indexPath) as! QJDJDetailsCollectionCell
            cell.detailsModel = detailsModelArray![indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(secondCellID, forIndexPath: indexPath) as! QJDJCollectionCell_2
            cell.detailsModel = detailsModelArray![indexPath.row]
            return cell
        }
    }
    // 点击cell跳转
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let shopVC = QJDJShopsViewController()
        let goodsID = detailsModelArray![indexPath.row].GoodsId
        // 商品控制器需要的参数
        shopVC.goodsID = goodsID
        //navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        navigationController?.pushViewController(shopVC, animated: true)
    }

}
    //MARK: - 点击导航条按钮以及topView上的按钮时执行的方法
extension QJDJDetailsVC {
    // 点击topView中的按钮时,需要执行闭包
    func setUpBlock() {
    
        // 销量
        topView!.xiaoliangBlockDown = {
            
            () -> ()
            in
            self.loadDataPaixu(1, newID: self.categoryID)
            
        }
        
        topView!.xiaoliangBlockUp = {
            
            () -> ()
            in
            self.loadDataPaixu(-1, newID: self.categoryID)
            
        }
        // 新品
        topView!.xinpinBlockDown = {
            
            () -> ()
            in
            self.loadDataPaixu(2, newID: self.categoryID)
            
        }
        topView!.xinpinBlockUp = {
            
            () -> ()
            in
            self.loadDataPaixu(-2, newID: self.categoryID)
            
        }
        
        // 价格
        
        topView!.jiageBlockDown = {
            
            () -> ()
            in
            self.loadDataPaixu(3, newID: self.categoryID)
            
        }
        
        topView!.jiageBlockUp = {
            
            () -> ()
            in
            self.loadDataPaixu(-3, newID: self.categoryID)
            
        }
        
    }
    
    // 闭包里的代码块
    
    func loadDataPaixu(sortFlag: Int, newID: Int) {
    
        let urlPaixu = "http://bmworld.cn:1234/Mobile/V1.asmx/GetCategoryGoodsList?StationId=3&CategoryId="+"\(newID)"+"&KeyWord=&pageSize=20&pageIndex=1&SortFlag="+"\(sortFlag)"+"&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
        SVProgressHUD.showWithStatus("正在加载数据,请稍后...")
        NetworkingTool().request(RequestType.requestTypeGet, URLString: urlPaixu, Parameter: nil) { (responseData, error) in
            guard let data = responseData else {
                
                SVProgressHUD.dismiss()
                return
            }
            guard let dictArray: [[String: AnyObject]] = data["DataList"] as? [[String: AnyObject]] else {
                return
            }
            var tempModelArray = [QJDJDetailsModel]()
            for dict in dictArray {
                let model = QJDJDetailsModel(dict: dict)
                tempModelArray.append(model)
            }
            self.detailsModelArray = tempModelArray
            self.detailsCollectionView_1?.reloadData()
            self.detailsCollectionView_2?.reloadData()
            self.hiddenFooter(dictArray.count)
            SVProgressHUD.dismiss()
        }
    }
    
    // 点击导航条右边按钮时执行的闭包
    func setUpNavRightBlock() {
    
        // 代理模式
        //buttonView.presentedDelegate = self
        // 闭包模式
        navBtnView!.pushBlock_1 = {
            () -> ()
            in
            if self.detailsModelArray?.count > 0 {
               self.detailsCollectionView_1!.removeFromSuperview()
               //self.view.addSubview(self.detailsCollectionView_2!)
                self.view.addSubview(self.placeHolderView!)
            }
        }
        
        navBtnView!.pushBlock_2 = {
            
            () -> ()
            in
            if self.detailsModelArray?.count > 0 {
                //self.detailsCollectionView_2!.removeFromSuperview()
                self.placeHolderView!.removeFromSuperview()
                self.view.addSubview(self.detailsCollectionView_1!)
            }
        }
    }

}

    //MARK: 判断是否需要隐藏上拉加载
extension QJDJDetailsVC {

    func hiddenFooter(count: Int) {
        if count < 20 {
            self.detailsCollectionView_1?.mj_footer.hidden = true
            self.detailsCollectionView_2?.mj_footer.hidden = true
        }
    }
}

