//
//  QJDJDiscoverControllerViewController.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import MJRefresh
class QJDJDiscoverController: UIViewController {

    private lazy var layout: QJDJDiscoveryFlowLayout = {
        let layout = QJDJDiscoveryFlowLayout()
        return layout
    }()
    private var disCollectView: UICollectionView?
    private var disModelArray: [QJDJDetailsModel]?
    private var navBarHidden: Bool = false
    private var navBarHeight: CGFloat = 64
    private let margin: CGFloat = 5
    private let screenW = UIScreen.mainScreen().bounds.width
    private let screenH = UIScreen.mainScreen().bounds.height
    private var pageIndex = 2
    private let backColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    lazy var netWorker = NetworkingTool()
    private let urlStr = "http://bmworld.cn:1234/Mobile/V1.asmx/GetCategoryGoodsList?StationId=3&CategoryId=0&KeyWord=&pageSize=20&pageIndex=1&SortFlag=0&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.title = "发现"
        view.backgroundColor = backColor
        setUpUI()
        disCollectView?.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
        loadData()
        disCollectView?.showsVerticalScrollIndicator = false
        setUpHeaderRefresh()
        setUpFooterRefresh()
    }
}
    //MARK: - 界面
extension QJDJDiscoverController {
    func setUpUI()  {
        let disPlaceHolderView = UIView(frame: CGRect(x: margin, y: navBarHeight, width: screenW - 2 * margin, height: screenH - navBarHeight))
        let disCollectView = UICollectionView(frame: disPlaceHolderView.bounds, collectionViewLayout: layout)
        disCollectView.dataSource = self
        disCollectView.delegate = self
        self.disCollectView = disCollectView
        disPlaceHolderView.addSubview(disCollectView)
        disCollectView.backgroundColor = backColor
        view.addSubview(disPlaceHolderView)
    }
}
    //MARK: - 添加上下拉刷新控件
extension QJDJDiscoverController {

    func setUpHeaderRefresh() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(QJDJDiscoverController.loadData))
        header.automaticallyChangeAlpha = true
        header.setTitle("正在刷新请稍后...", forState: .Refreshing)
        disCollectView?.mj_header = header
    }
    func setUpFooterRefresh() {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(QJDJDiscoverController.loadMoreData))
        footer.automaticallyHidden = true
        footer.setTitle("正在加载,请稍后...", forState: .Refreshing)
        disCollectView?.mj_footer = footer
    }
}
    //MARK: - 请求数据
extension QJDJDiscoverController {

    func loadData() {
        netWorker.request(RequestType.requestTypeGet, URLString: urlStr, Parameter: nil) { (responseData, error) in
            self.disCollectView?.mj_header.endRefreshing()
            guard let data = responseData else {
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
            self.disModelArray = tempModelArray
            self.disCollectView?.reloadData()
            if dictArray.count < 20 {
                self.disCollectView?.mj_footer.hidden = true
            }
        }
    }
    func loadMoreData() {
        let urlStr = "http://bmworld.cn:1234/Mobile/V1.asmx/GetCategoryGoodsList?StationId=3&CategoryId=0&KeyWord=&pageSize=20&pageIndex="+"\(pageIndex)"+"&SortFlag=0&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
        // 取消下拉
        netWorker.request(RequestType.requestTypeGet, URLString: urlStr, Parameter: nil) { (responseData, error) in
            guard let data = responseData else {
                return
            }
            guard let dictArray: [[String: AnyObject]] = data["DataList"] as? [[String: AnyObject]] else {
                return
            }
            self.disCollectView?.mj_footer.endRefreshing()
            var tempModelArray = [QJDJDetailsModel]()
            for dict in dictArray {
                let model = QJDJDetailsModel(dict: dict)
                tempModelArray.append(model)
            }
            self.disModelArray = self.disModelArray! + tempModelArray
            self.disCollectView?.reloadData()
            if dictArray.count > 0 {
                self.pageIndex += 1
            }
            if dictArray.count < 20 {
                self.disCollectView?.mj_footer.hidden = true
            }
        }
    }
}

    //MARK: - 代理和数据源方法
    extension QJDJDiscoverController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = disModelArray?.count else {
            return 0
        }
        return count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       let cellID = "disCell"
        let nib = UINib(nibName: "QJDJDiscoveryCell", bundle: NSBundle.mainBundle())
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellID)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! QJDJDiscoveryCell
        cell.detailsModel = disModelArray?[indexPath.row]
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }        
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            print("123")
            // 点击跳转到购买详情控制器
            let shopVC = QJDJShopsViewController()
            let goodsID = disModelArray![indexPath.row].GoodsId
            // 商品控制器需要的参数
            shopVC.goodsID = goodsID
            navigationController?.pushViewController(shopVC, animated: true)
        }
}

