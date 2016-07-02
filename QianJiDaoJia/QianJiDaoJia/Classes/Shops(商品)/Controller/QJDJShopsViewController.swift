//
//  QJDJShopsViewController.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/21.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import SDCycleScrollView
import SwiftyJSON

class QJDJShopsViewController: UITableViewController {
    
    private let cellID = "shopCommentCell"
    
    private var shopItem: ShopItem? // 最外层商品模型
    private var goodsAttributeItem: [ShopMessageItem]? // 商品的一些属性模型（数组里就一个模型）
    
    var goodsID: Int = 0 {
        willSet {
            self.urlStr = "http://bmworld.cn:1234/Mobile/V1.asmx/GetSingleGoodsInfo?GoodsId=\(newValue)&StationId=3&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
        }
    }
    private var urlStr: String?

    // 懒加载头部视图
    private lazy var headerV: QJDJShopHeaderView? = {
        let headerV = QJDJShopHeaderView.viewFromNib()
        return headerV
    }()
    
    // 懒加载footerView
    private lazy var footerV: QJDJFootView? = {
        let footerV = QJDJFootView.viewFromNib()
        return footerV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView() // 设置tableView
        requestNetWorkData() // 请求网络数据
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1)
        // 注册评论cell
        tableView.registerNib(UINib(nibName: "QJDJShopCommentCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0) // 处理底部条挡住内容
        // 设置headerView
        tableView.tableHeaderView = headerV
        tableView.rowHeight = 50
        // 设置footerView
        tableView.tableFooterView = footerV
    }
    
    // 请求网络数据
    private func requestNetWorkData(){
        NetworkingTool().request(RequestType.requestTypeGet, URLString: urlStr!, Parameter: nil) { (responseData, error) in
            if error != nil {return}
            
            guard let data = responseData else {return}
            let dict = JSON(data).dictionaryObject! as NSDictionary
            self.shopItem = ShopItem.mj_objectWithKeyValues(dict) // 最外层模型
            self.goodsAttributeItem = (self.shopItem?.GoodsAttributeList)! as [ShopMessageItem]
            self.headerV?.shopItem = self.shopItem
            self.headerV?.goodsItem = (self.goodsAttributeItem?.first)! as ShopMessageItem // 数组里就一个模型
            
//            self.tableView.tableFooterView = self.headerV
//            self.tableView.tableFooterView = self.footerV
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: QJDJShopCommentCell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! QJDJShopCommentCell
        cell.shopItem = self.shopItem
        return cell
    }
    
    // 点击进入商品评论区
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(QJDJCommentController(), animated: true)
    }
}
