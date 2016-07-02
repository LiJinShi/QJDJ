//
//  QJDJCollectViewController.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/23.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit
import SwiftyJSON

class QJDJCollectViewController: UITableViewController {

    let cellID = "collectCell"
    // 懒加载模型数组
    lazy var collectItems = NSArray()
    
    var urlStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView() 
        rquestData() // 请求这个页面的数据
    }
    
    func setupTableView(){
        navigationItem.title = "我的收藏"
        tableView.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1)
        tableView.registerNib(UINib(nibName: "QJDJCollectCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.rowHeight = 105
        tableView.tableFooterView = UIView() // 去掉没有数据的cell
    }
    
    // 网络请求
    func rquestData() {
//        let urlStr = "http://bmworld.cn:1234/Mobile/V1.asmx/GetUserFavoriteList?UserId=98&StationId=3&PageSize=20&PageIndex=1&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
        NetworkingTool().request(RequestType.requestTypeGet, URLString: urlStr!, Parameter: nil) { (responseData, error) in
            if error != nil {return}
            
            guard let responseData = responseData else {return}
            let dictArray = JSON(responseData)["DataList"].arrayObject
            self.collectItems = CollectShopItem.mj_objectArrayWithKeyValuesArray(dictArray)            
            self.tableView.reloadData()
        }
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate
extension QJDJCollectViewController {
    // 返回cell的个数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectItems.count
    }
    // 返回cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! QJDJCollectCell
        cell.collectItem = collectItems[indexPath.row] as? CollectShopItem
        return cell
    }
    // 监听cell的点击
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = collectItems[indexPath.row] as! CollectShopItem
        let vc = QJDJShopsViewController()
        vc.goodsID = item.GoodsId
        navigationController?.pushViewController(vc, animated: true)
    }
}

