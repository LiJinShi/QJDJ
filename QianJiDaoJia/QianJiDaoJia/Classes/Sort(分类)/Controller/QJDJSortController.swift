//
//  QJDJSortController.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 LJS. All rights reserved.
//  分类主界面

import UIKit
import SVProgressHUD
class QJDJSortController: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var infoTableView: UITableView!
    
    private var infoCollectionView: UICollectionView?
    private var rightCell: QJDJInfoCell?
    private var selectedCategoryModel: QJDJCategoryModel?
    private let urlStr = "http://bmworld.cn:1234/Mobile/V1.asmx/GetGoodsCategoryList?StationId=3&CategoryFatherId=0&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
    private var urlStrInfo: String = ""
    
    private let infoSquareCellID: String = "infoSquareCell"
    
    // 模型数组
    private var categoryModelArray: [QJDJCategoryModel]?
    
    private var squareModelArray: [QJDJSquareModel]?
    
 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "分类"

        infoTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        categoryTableView.separatorStyle = .None
        infoTableView.separatorStyle = .None
        infoTableView.showsVerticalScrollIndicator = false

        // 弹簧效果
        categoryTableView.bounces = true
        infoTableView.bounces = false

        loadCategoryData(urlStr)
        loadInfoData(urlStrInfo)
        setUpFootView()
    }
    
    // 当网速忙的时候一定要调试
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
}

    //MARK: 加载数据
extension QJDJSortController {
    // 左边数据
    func loadCategoryData(urlStr: String) {
        
        SVProgressHUD.showWithStatus("正在加载数据,请稍后...")
        //,网络工具类,请求到json数据,字典转模型,添加到数组中
        NetworkingTool().request(RequestType.requestTypeGet, URLString: urlStr, Parameter: nil) { (responseData, error) in
            guard let data = responseData else {
                SVProgressHUD.dismiss()
                return
            }
            let dictArray: [[String: AnyObject]] = (data["DataList"] as? [[String: AnyObject]])!
            var tempModelArray = [QJDJCategoryModel]()
            for dict in dictArray {
                let model = QJDJCategoryModel(dict: dict)
                tempModelArray.append(model)
        }
        self.categoryModelArray = tempModelArray
        let count: CGFloat = CGFloat((self.categoryModelArray?.count)!)
        let cols: CGFloat = 3
        let rows: CGFloat = count / cols + 1
           // print(rows)
        let collectViewHeight = rows * ((UIScreen.mainScreen().bounds.width - 100) / cols)
        self.infoCollectionView?.frame.size.height = collectViewHeight
            //print(collectViewHeight)
        // 先刷新表格在自动选中
        self.categoryTableView.reloadData()
        SVProgressHUD.dismiss()
        let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.categoryTableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
        self.tableView(self.categoryTableView, didSelectRowAtIndexPath: indexPath)
        }
    }
    // 加载右边数据
        func loadInfoData(urlStr: String) {
            SVProgressHUD.showWithStatus("正在加载数据,请稍后...")
            NetworkingTool().request(RequestType.requestTypeGet, URLString: urlStrInfo, Parameter: nil) { (responseData, error) in
                guard let data = responseData else {
                    SVProgressHUD.dismiss()
                    return
                }
                let dictArray: [[String: AnyObject]] = (data["DataList"] as? [[String: AnyObject]])!
                var tempModelArray = [QJDJSquareModel]()
                for dict in dictArray {
                    let model = QJDJSquareModel(dict: dict)
                    tempModelArray.append(model)
                }
                self.squareModelArray = tempModelArray
                self.infoTableView.reloadData()
                self.infoCollectionView?.reloadData()
                SVProgressHUD.dismiss()
        }
    }
}

    //MARK: - 数据源方法,代理方法
extension QJDJSortController: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 判断是左边还是右边
        if tableView == categoryTableView {
            guard let count = categoryModelArray?.count else {
                return 0
            }
            return count
        }
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == categoryTableView {
            // 左边的cell
           let cell = QJDJCategoryCell.cellWithTableView(tableView)
            cell.categoryModel = categoryModelArray![indexPath.row]
            return cell
        }
        // 右边的cell
       let cell = QJDJInfoCell.cellWithTableView(tableView)
        self.rightCell = cell
       return cell
    }
    // 点击左侧cell时调用
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == categoryTableView {
            guard let categoryModelArray = self.categoryModelArray else {
                return
            }
            selectedCategoryModel = categoryModelArray[indexPath.row]
            rightCell?.infoNameLabel.text = selectedCategoryModel?.CategoryName
            let CategoryID = selectedCategoryModel?.CategoryId
            urlStrInfo = "http://bmworld.cn:1234/Mobile/V1.asmx/GetGoodsCategoryList?StationId=3&CategoryFatherId="+"\(CategoryID!)"+"&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
            loadInfoData(urlStrInfo)
            // 刷新
            infoCollectionView?.reloadData()
            self.infoTableView.reloadData()
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}
    //MARK: - 右边底部的collectionView
extension QJDJSortController: UICollectionViewDataSource, UICollectionViewDelegate {
    func setUpFootView() {
        infoTableView.tableFooterView = setUpCollectView()
    }
}
    //MARK: - 创建collectionView
extension QJDJSortController {
    func setUpCollectView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let cols: CGFloat = 3
        let categoryTableWidth: CGFloat = 100
        let itemWH = (UIScreen.mainScreen().bounds.width - categoryTableWidth) / cols
        layout.itemSize = CGSize(width: itemWH, height: itemWH + 10)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        // 注册cell
        collectionView.registerNib(UINib.init(nibName: "QJDJInfoSquareViewCell", bundle: nil), forCellWithReuseIdentifier: infoSquareCellID)
        collectionView.showsVerticalScrollIndicator = false
        self.infoCollectionView = collectionView
        return collectionView
    }
}
    //MARK: - 右边底部的collectionView数据源方法和代理方法

extension QJDJSortController {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = squareModelArray?.count else {
            return 0
        }
        return count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(infoSquareCellID, forIndexPath: indexPath) as? QJDJInfoSquareViewCell
        cell!.squareModel = squareModelArray![indexPath.row]
        return cell!
    }
    // 点击square时
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 跳转到另一个控制器
        let detailsVC = QJDJDetailsVC()        
        let model = squareModelArray![indexPath.row]
        detailsVC.navigationItem.title = model.CategoryName
        detailsVC.categoryID = model.CategoryId
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}


