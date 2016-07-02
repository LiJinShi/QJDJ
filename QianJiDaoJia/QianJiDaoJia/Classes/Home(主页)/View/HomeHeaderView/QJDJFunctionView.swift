//
//  QJDJFunctionView.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/18.
//  Copyright © 2016年 LJS. All rights reserved.
//  天天特惠等按钮功能模块

import UIKit

protocol QJDJFunctionViewDelegate: NSObjectProtocol {
    func didselectedFunctionItem(type: functionType)
}

enum functionType: String {
    case TianTianTeHui = "-2"
    case ReXiao = "-3"
    case XinPing = "-4"
    case QianJi = "-5"
    case WeiYuan = "181"
    case ShouChang = "http://bmworld.cn:1234/Mobile/V1.asmx/GetUserFavoriteList?UserId=98&StationId=3&PageSize=20&PageIndex=1&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
    case ChaDingDang = "http://bmworld.cn:1234/Mobile/V1.asmx/GetOrderList?pageSize=20&pageIndex=1&UserId=98&OrderState=1&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
    case LingQianDou = "http://bmworld.cn:1234/Mobile/V1.asmx/UserSignin?UserId=98&Key=483112281215-3726efb4-7206-4fd0-99b0-3dea4c58fe2e"
}

class QJDJFunctionView: UIView {
    
    private var functionCellID = "funcCellID"  
    
    weak var delegate: QJDJFunctionViewDelegate?
    // 点击不同按钮跳转到分类控制器，这个数组里就是url的参数
    lazy var item = [functionType.TianTianTeHui, functionType.ReXiao, functionType.XinPing, functionType.QianJi, functionType.WeiYuan, functionType.ShouChang, functionType.ChaDingDang, functionType.LingQianDou]
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addCollectionView() // 添加collectionView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 添加collectionView
    private func addCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        let cols: CGFloat = 4 // 列数
        let rows: CGFloat = 2 // 行数
        // 设置cell的尺寸
        layout.itemSize = CGSize(width: self.bounds.width/cols, height: self.bounds.height/rows)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), collectionViewLayout: layout)
        addSubview(collectionView)
        collectionView.userInteractionEnabled = true
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.contentSize = CGSizeZero // 水平和垂直都不让滚动
        collectionView.dataSource = self // 设置数据源
        collectionView.delegate = self
        collectionView.scrollsToTop = false // 禁用掉这个属性
        // 注册cell
        let nib = UINib(nibName: String(QJDJFuncCollectionCell.classForCoder()), bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: functionCellID)
    }
}

// MARK:- UICollectionViewDataSource
extension QJDJFunctionView: UICollectionViewDataSource, UICollectionViewDelegate {
    // cell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    // 返回cell的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: QJDJFuncCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(functionCellID, forIndexPath: indexPath) as! QJDJFuncCollectionCell
        cell.index = indexPath.item
        return cell
    }
    // 点击cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let type: functionType = item[indexPath.row]
        delegate?.didselectedFunctionItem(type)
    }
}




