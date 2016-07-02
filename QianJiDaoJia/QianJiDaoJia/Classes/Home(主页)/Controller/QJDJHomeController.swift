//
//  QJDJHomeController.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import SDCycleScrollView
import SwiftyJSON
import MJExtension
import SVProgressHUD
import MJRefresh

class QJDJHomeController: UITableViewController {    
    private let oneCellID = "oneCell" // 只有一张图片的cell
    private let twoCellID = "twoCell" // 序号为2的那个cell
    private let threeCellID = "threeCell" // 有三张图片但序号不为2的那个cell
    // 懒加载模型数组(底部cell)
    private lazy var bottomCellItems = [BottomCellItem]() // 最外层模型数组
    private lazy var picItems = [PicItem]() // 单个cell内图片模型
    private lazy var imageUrlArr = [String]() // 保存顶部轮播图片的url
    private lazy var bannerItems = [BannerViewItem]() // 保存顶部数据模型
    // 轮播文字数组
    private lazy var textArr = [String]()
    private lazy var forwardItems = [ForwardSaleItem]()
    private let chaDingDangUrlStr = "http://bmworld.cn:1234/Mobile/V1.asmx/GetOrderList?pageSize=20&pageIndex=1&UserId=98&OrderState=1&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
    private let lingQiangDouUrlStr = "http://bmworld.cn:1234/Mobile/V1.asmx/UserSignin?UserId=98&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
    // 懒加载一个动画,在cell将显示时出现放大效果
    private var animation: CABasicAnimation = {
        // 缩放动画
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.3
        animation.toValue = 1
        animation.duration = 0.5
        return animation
    }()
    var homeHeaderView: QJDJHomeHeaderView?
    
    var isGetTopViewData: Bool = false
    var isGetLabelBannerData: Bool = false
    var isGetForwardSaleData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView() // 设置tableView
        setupHeaderRefresh() // 设置下拉刷新
        
        getData() // 得到各模块数据
    }
    // 得到各模块数据
    private func getData() {
        // 顶部图片轮播数据操作
        let dictsTopBannerView = readcachesTopBannerData()
        if dictsTopBannerView.count > 0{ // 数据库有数据
            print("TopBannerView来自数据库")
            setHeaderTopViewData(dictsTopBannerView)
        } else {
            print("TopBannerView来自网络请求")
            requestTopViewData()
        }
        // 请求轮播文字
        let dictsLabelBanner = readLabelBannerData()
        if dictsLabelBanner.count > 0 {
            print("LabelBanner来自数据库")
            setupLabelBannerData(dictsLabelBanner)
        }else {
            print("LabelBanner来自网络请求")
            requestLabelBannerData()
        }
        // 请求预售模块数据
        let dictsForwardSale = readForwardSaleData()
        if dictsForwardSale.count > 0{
            print("ForwardSale来自数据库")
            setupForwardSaleData(dictsForwardSale)
        }else {
            print("ForwardSale来自网络请求")
            requestforwardSaleData()
        }
        // 请求底部cell数据
        let dictsBottomCell = readBottomCellData()
        if dictsBottomCell.count > 0{
            print("BottomCell来自数据库")
            setupBottomCellData(dictsBottomCell)
        }else {
            print("BottomCell来自网络请求")
            requestBottomCellData()
        }
    }
    
    // 添加下拉刷新控件
    private func setupHeaderRefresh() {
        let header = MJRefreshNormalHeader { 
            self.requestTopViewData() // 顶部轮播数据
            self.requestLabelBannerData() // 请求文字轮播的数据
            self.requestforwardSaleData() // 请求预售模块数据
            self.requestBottomCellData() // 请求底部cell数据
        }
        self.tableView.mj_header = header
    }
    // 设置tableView
    private func setupTableView() {
        self.navigationItem.title = "主页" // 设置导航条title
        tableView.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        tableView.separatorStyle = .None // 取消cell分隔线
        // 注册只有一张图的cell(类注册)
        tableView.registerClass(QJDJCell.classForCoder(), forCellReuseIdentifier: oneCellID)
        // 注册序号为2的那个cell
        tableView.registerNib(UINib(nibName: "QJDJTwoCell", bundle: nil), forCellReuseIdentifier: twoCellID)
        // xib注册有三张图的cell
        tableView.registerNib(UINib(nibName: "QJDJThreeCell", bundle: nil), forCellReuseIdentifier: threeCellID)
        
        // 设置headerView
        let rect = CGRect(x: 0, y: 0, width: HomeItem.shareHomeItem.topViewW, height: HomeItem.shareHomeItem.headerViewH)
        let headerV = QJDJHomeHeaderView(frame: rect)
        headerV.delegate = self
        tableView.tableHeaderView = headerV
        homeHeaderView = headerV
        tableView.rowHeight = HomeItem.shareHomeItem.bottomCellH + 4
    }
}

// MARK:- 网络请求与缓存操作
extension QJDJHomeController{
    /***************************顶部轮播View网络请求与数据库操作**********************************/
    // 请求顶部轮播View数据
    private func requestTopViewData() {
        let url = "http://bmworld.cn:1234/Mobile/V1.asmx/GetHomeBannerList?StationId=3&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
        
        NetworkingTool().request(RequestType.requestTypeGet, URLString: url, Parameter: nil) { (responseData, error) in
            if error != nil {return} // 有错误
            guard let dat = responseData else {return}
            let data = JSON(dat)
            guard let dictArray = data["DataList"].arrayObject else {return}
            let dicts = dictArray as! [[String: NSObject]]
            self.cachesTopBannerData(dicts) // 将 字典数组 存储到数据库
            self.setHeaderTopViewData(dicts)
        }
    }
    // 缓存 顶部轮播View数据
    private func cachesTopBannerData(dicts: [[String: NSObject]]) {
        SQLiteTool.shareInstance.dropTable("T_topBanner")
        SQLiteTool.shareInstance.createTable("T_topBanner", column: "dict")
        for dict in dicts{
            // 将每个字典序列化成NSData类型
            guard let data = try? NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)else {
                continue
            }
            SQLiteTool.shareInstance.saveDataTo("T_topBanner", column: "dict", data: data) // 保存数据
        }
    }
    // 读取顶部轮播的缓存数据（返回字典数组）
    private func readcachesTopBannerData() -> [[String: NSObject]] {
        var dicts: [[String: NSObject]] = []
        SQLiteTool.shareInstance.queryTable("T_topBanner") { (result) -> (Void) in
            guard (result != nil) else {return}
            while result.next() {
                let data = result.stringForColumn("dict").dataUsingEncoding(NSUTF8StringEncoding)
                let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String: NSObject]
                dicts.append(dict!)
            }
        }
        return dicts // 返回读取到的字典数组
    }
    // 给控件设置
    private func setHeaderTopViewData(dicts: [[String: NSObject]]){
        self.bannerItems.removeAll()
        self.bannerItems = BannerViewItem.mj_objectArrayWithKeyValuesArray(dicts).copy() as! [BannerViewItem] // 转成模型数组
        self.imageUrlArr.removeAll()
        for bannerItem in self.bannerItems { // 取出图片url地址方便给轮播器赋值
            let imageUrl: String = bannerItem.BannerCutPath1!
            self.imageUrlArr.append(imageUrl)
        }
        let headerTopView = self.homeHeaderView!.subviews[0] as! QJDJHeaderTopView
        headerTopView.imageUrlArr = self.imageUrlArr
        headerTopView.bannerItems = self.bannerItems
        isGetTopViewData = true
    }
    
    /***************************文字轮播网络请求与数据库操作**********************************/
    // 请求文字轮播的数据
    private func requestLabelBannerData() {
        let url = "http://bmworld.cn:1234/Mobile/V1.asmx/GetHomeNoticeList?StationId=3&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
        
        NetworkingTool().request(RequestType.requestTypeGet, URLString: url, Parameter: nil) { (responseData, error) in
            if error != nil {return} // 有错误
            guard let dat = responseData else {return}
            let data = JSON(dat)
            guard let dictArray = data["DataList"].arrayObject else{return}
            
            self.cachesLabelBannerData(dictArray as! [[String: NSObject]]) // 缓存数据
            self.setupLabelBannerData(dictArray as! [[String: NSObject]])
        }
    }
    // 缓存数据
    private func cachesLabelBannerData(dicts: [[String: NSObject]]) {
        SQLiteTool.shareInstance.dropTable("T_LabelBannerData")
        SQLiteTool.shareInstance.createTable("T_LabelBannerData", column: "dict")
        for dict in dicts{
            guard let data = try? NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted) else {return}
            SQLiteTool.shareInstance.saveDataTo("T_LabelBannerData", column: "dict", data: data)
        }
    }
    // 读取数据
    private func readLabelBannerData() -> [[String: NSObject]] {
        var dicts: [[String: NSObject]] = []
        SQLiteTool.shareInstance.queryTable("T_LabelBannerData") { (result) -> (Void) in
            guard (result != nil) else {return}
            while result.next() {
                let data = result.stringForColumn("dict").dataUsingEncoding(NSUTF8StringEncoding)
                let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String: NSObject]
                dicts.append(dict!)
            }
        }
        return dicts
    }
    // 给控件设值
    private func setupLabelBannerData(dicts: [[String: NSObject]]){
        self.textArr.removeAll()
        for dict in dicts {
            let text: String = dict["NoticeText"] as! String
            self.textArr.append(text)
        }
        let labelBanner = self.homeHeaderView!.subviews[1] as! QJDJLabelBanner
        labelBanner.textArr = self.textArr
        self.isGetLabelBannerData = true
    }
    
    /***************************预售模块网络请求与数据库操作**********************************/
    // 请求预售模块数据
    private func requestforwardSaleData() {
        
        let urlStr = "http://bmworld.cn:1234/Mobile/V1.asmx/GetCategoryGoodsList?StationId=3&CategoryId=-1&KeyWord=&pageSize=20&pageIndex=1&SortFlag=0&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
        // 设置连网状态
        NetworkingTool().request(RequestType.requestTypeGet, URLString: urlStr, Parameter: nil) { (responseData, error) in
            if error != nil {return}
            guard let dat = responseData else {return}
            guard let dictArray = JSON(dat)["DataList"].arrayObject else {return}
            
            self.cachesForwardSaleData(dictArray as! [[String: NSObject]])
            self.setupForwardSaleData(dictArray as! [[String: NSObject]])
        }
    }
    // 缓存数据
    private func cachesForwardSaleData(dicts: [[String: NSObject]]){
        SQLiteTool.shareInstance.dropTable("T_forWradSaleData")
        SQLiteTool.shareInstance.createTable("T_forWradSaleData", column: "dict")

        for dict in dicts{
            let data = try? NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            SQLiteTool.shareInstance.saveDataTo("T_forWradSaleData", column: "dict", data: data!)
        }
    }
    // 读取数据
    private func readForwardSaleData() -> [[String: NSObject]]{
        var dicts: [[String: NSObject]] = []
        SQLiteTool.shareInstance.queryTable("T_forWradSaleData") { (result) -> (Void) in
            while result.next() {
                let data = result.stringForColumn("dict").dataUsingEncoding(NSUTF8StringEncoding)
                let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                dicts.append(dict as! [String : NSObject])
            }
        }
        return dicts
    }
    // 给控件设值
    private func setupForwardSaleData(dicts: [[String: NSObject]]) {
        self.forwardItems.removeAll()
        self.forwardItems = ForwardSaleItem.mj_objectArrayWithKeyValuesArray(dicts).copy() as! [ForwardSaleItem]
        let forwardSaleView = self.homeHeaderView!.subviews[3] as! QJDJForwardSaleView
        forwardSaleView.forwardItems = self.forwardItems
        self.isGetForwardSaleData = true
    }
    
    /***************************底部cell网络请求与数据库操作**********************************/
    // 请求底部cell数据
    private func requestBottomCellData() {
        let urlStr = "http://bmworld.cn:1234/Mobile/V1.asmx/GetHomeTemplate?StationId=3&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
        NetworkingTool().request(RequestType.requestTypeGet, URLString: urlStr, Parameter: nil) { (responseData, error) in
            if error != nil {return}
            
            guard let data = responseData else {return}
            let dictArray = JSON(data)["TemplateContent"].arrayObject! // 取到字典数组
            
            self.cachesBottomCellData(dictArray as! [[String: NSObject]]) // 缓存数据
            self.setupBottomCellData(dictArray as! [[String: NSObject]])
        }
    }
    private func cachesBottomCellData(dicts: [[String: NSObject]]){
        SQLiteTool.shareInstance.dropTable("T_BottomCellData")
        SQLiteTool.shareInstance.createTable("T_BottomCellData", column: "dict")
        for dict in dicts {
            let data = try? NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            SQLiteTool.shareInstance.saveDataTo("T_BottomCellData", column: "dict", data: data!)
        }
    }
    private func readBottomCellData() -> [[String: NSObject]]{
        var dicts: [[String: NSObject]] = []
        SQLiteTool.shareInstance.queryTable("T_BottomCellData") { (result) -> (Void) in
            while result.next(){
                guard let data = result.stringForColumn("dict")?.dataUsingEncoding(NSUTF8StringEncoding) else {return}
                let dict = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String: NSObject]
                dicts.append(dict!)
            }
        }
        return dicts
    }
    private func setupBottomCellData(dicts: [[String: NSObject]]) {
        self.bottomCellItems.removeAll()
        // 将字典数组转为模型数组
        self.bottomCellItems = BottomCellItem.mj_objectArrayWithKeyValuesArray(dicts).copy() as! [BottomCellItem]
        
        // 只有当其余view内控件数据都设置好后才刷新tableView
        while self.isGetTopViewData == false && self.isGetLabelBannerData == false && self.isGetForwardSaleData == false {} 
        self.tableView.mj_header.endRefreshing()
        SVProgressHUD.showSuccessWithStatus("更新数据成功")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { 
            SVProgressHUD.dismiss()
        })
        self.tableView.reloadData()
    }
}

// MARK:- UITableViewDataSource
extension QJDJHomeController {
    // 有多少行
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bottomCellItems.count
    }

    // 返回每个cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 取出cell模型
        let bottomItem = self.bottomCellItems[indexPath.row] 
        
        // 根据模型数据内字段进行判断cell类型
        if bottomItem.PicType == 1 { // 1张图
            let cell: QJDJCell = tableView.dequeueReusableCellWithIdentifier(oneCellID) as! QJDJCell
            cell.delegate = self
            cell.picItem = bottomItem.PicArray?.first
            return cell
        } else if bottomItem.PicType == 3 { // 3张竖图
            let cell: QJDJTwoCell = tableView.dequeueReusableCellWithIdentifier(twoCellID) as! QJDJTwoCell
            cell.delegate = self
            cell.picItems = bottomItem.PicArray
            return cell
        } else { // 3张，左边两张，右边一张
            let cell: QJDJThreeCell = tableView.dequeueReusableCellWithIdentifier(threeCellID) as! QJDJThreeCell
            cell.delegate = self
            cell.picItems = bottomItem.PicArray
            return cell
        }
    }
    // cell将显示时设置动画
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        for subV in cell.contentView.subviews {
            subV.layer.addAnimation(animation, forKey: nil)
        }
    }
}

// MARK:- 监听cell内的点击
extension QJDJHomeController: QJDJCellDelegate, QJDJThreeCellDelegate, QJDJTwoCellDelegate {
    // 抽取一个公共方法
    func pushDetailsVC(categoryID: Int, title: String) {
        let VC = QJDJDetailsVC()
        VC.categoryID = categoryID
        VC.navigationItem.title = title
        navigationController?.pushViewController(VC, animated: true)
    }
    func pushShopsViewVC(goodsID: Int){
        let VC = QJDJShopsViewController()
        VC.goodsID = goodsID
        navigationController?.pushViewController(VC, animated: true)
    }
    
    // 点击了一张图的cell
    func didselectOneCellImage(picItem: PicItem) { 
        let VC = QJDJDetailsVC()
        if !(picItem.Value?.containsString("http://"))! {
            VC.categoryID = Int(picItem.Value!)!
            VC.navigationItem.title = picItem.Title
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    // 点击了三张图的cell（左边两张，右边一张）
    func didselectThreeCellLeftTopImage(goodsID: Int) { // 点击左上角图片
        pushShopsViewVC(goodsID)
    }
    func didselecThreeCellBottomImage(goodsID: Int) { // 点击左下角图片
        pushShopsViewVC(goodsID)
    }
    func didselectThreeCellRightImage(goodsID: Int) { // 点击了右边图片
        pushShopsViewVC(goodsID)
    }
    // 点击三张竖图的cell
    func didselectTwoCellLeftImage(categoryID: Int, title: String) {
        pushDetailsVC(categoryID, title: title)
    }
    func didselectTwoCellMiddleImage(categoryID: Int, title: String) {
        pushDetailsVC(categoryID, title: title)
    }
    func didselectTwoCellRightImage(categoryID: Int, title: String) {
        pushDetailsVC(categoryID, title: title)
    }
}

//MARK:- 监听HeaderView内各控制的点击
extension QJDJHomeController: QJDJHomeHeaderViewDelegate {
    // 点击轮播器跳转到相应控制器
    func touchBannerImageView(categoryID: Int) {
        let VC = QJDJDetailsVC()
        VC.categoryID = categoryID
        navigationController?.pushViewController(VC, animated: true)
    }
    
    // 点击到functionView中按钮
    func didselectedFunctionItem(type: functionType) {
        
        let VC = QJDJDetailsVC()
        if !type.rawValue.containsString("http://") {
            VC.categoryID = Int(type.rawValue)!
            navigationController?.pushViewController(VC, animated: true)
        }
        
        switch type {
        case .ShouChang:
            didselectShouChangItem(type.rawValue)
        case .LingQianDou:
            didselectLingQianDou(type.rawValue)
        case .ChaDingDang:
            didselectChaDingDangItem(type.rawValue)
        default: break
        }
    }
    
    // 点击(到家秒杀)预售模块中的cell
    func didSelectedForwardSaleItem(forwardSaleItem: ForwardSaleItem) {
        let VC = QJDJShopsViewController()
        VC.goodsID = forwardSaleItem.GoodsId // 将商品ID传递到控制器
        navigationController?.pushViewController(VC, animated: true)
    }
    
    // 点击了收藏
    func didselectShouChangItem(url: String) {
        let vc = QJDJCollectViewController()
        vc.urlStr = url
        navigationController?.pushViewController(vc, animated: true)
    }
    // 点击了查订单
    func didselectChaDingDangItem(url: String) {
        print("点击了查订单")
    }
    // 点击了领钱豆
    func didselectLingQianDou(url: String) {
        requestLingQianDouData(url)
    }
    // 领钱豆的网络请求
    func requestLingQianDouData(urlStr: String) {
        SVProgressHUD.showWithStatus("请等待...")
        NetworkingTool().request(RequestType.requestTypeGet, URLString: urlStr, Parameter: nil) { (responseData, error) in
            if error != nil {return}
            
            guard let data = responseData else {return}
            let message = JSON(data)["Message"].stringValue
            let signinCount = JSON(data)["SigninCount"].int
            if message == "OK" && signinCount == 0{
                SVProgressHUD.showSuccessWithStatus("今日签到成功")
            } else {
                SVProgressHUD.showSuccessWithStatus("今日你已经签到过了")
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), { 
                SVProgressHUD.dismiss()
            })
        }
    }
}
