//
//  QJDJForwardSaleView.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/18.
//  Copyright © 2016年 LJS. All rights reserved.
//  预售模块

import UIKit
import SDAutoLayout
import SwiftyJSON
import MJExtension

protocol QJDJForwardSaleViewDelegate: NSObjectProtocol {
    func didSelectedForwardSaleItem(forwardSaleItem: ForwardSaleItem) -> ()
}

class QJDJForwardSaleView: UIView {

    private let forwardCellID = "forwardCellID"
    private let space: CGFloat = 10 // 这个view下面一条分隔线的高度
    
    weak var delegate: QJDJForwardSaleViewDelegate?
    
    // MARK:- 懒加载属性
    // 懒加载label(到家秒杀)
    private lazy var label: UILabel = {
        let labelRect = CGRect(x: 5, y: 5, width: 0, height: 20)
        let label = UILabel(frame: labelRect)
        label.text = "到家秒杀"
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.systemFontOfSize(17)
        label.sizeToFit()
        return label
    }()
    // 懒加载layout布局
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let cols: CGFloat = 4.5 // 列数
        let rows: CGFloat = 1 // 行数
        // 设置cell的尺寸
        layout.itemSize = CGSize(width: self.bounds.width/cols, height: (self.bounds.height - CGRectGetMaxY(self.label.frame) - self.space)/rows)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }() 
    // 懒加载collectionView
    private lazy var collectionView: UICollectionView = {
        let collectionViewY = CGRectGetMaxY(self.label.frame)
        let collectionViewH = self.bounds.height - collectionViewY - self.space
        let collectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: collectionViewY, width: self.bounds.width, height: collectionViewH), collectionViewLayout: self.layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self // 设置数据源
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.scrollsToTop = false // 禁用掉这个属性
        // 注册cell
        let nib = UINib(nibName: String(QJDJForwardSaleCell.classForCoder()), bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: self.forwardCellID)
        return collectionView
    }()
    // 懒加载底部一个UIVeiw,用来作分隔线
    private lazy var spaceView: UIView = {
        
        let y = CGRectGetMaxY(self.collectionView.frame)
        let rect = CGRect(x: 0, y: y, width: self.bounds.width, height: self.space)
        let spaceView: UIView = UIView(frame: rect)
        spaceView.backgroundColor = UIColor.lightGrayColor()
        return spaceView
    }()
    
    var forwardItems: [ForwardSaleItem]? {
        didSet {
            collectionView.reloadData()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        addSubview(label) // 添加顶部label
        addSubview(collectionView) // 添加collectionView
        addSubview(spaceView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

// MARK:- UICollectionViewDataSource UICollectionViewDelegate
extension QJDJForwardSaleView: UICollectionViewDataSource, UICollectionViewDelegate {
    // cell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forwardItems == nil ? 0 : (forwardItems?.count)!
    }
    // 返回cell的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: QJDJForwardSaleCell = collectionView.dequeueReusableCellWithReuseIdentifier(forwardCellID, forIndexPath: indexPath) as! QJDJForwardSaleCell
        cell.item = forwardItems![indexPath.row]
        return cell
    }
    
    // 点击cell跳转,将cell的模型传递出去，在外面控制器根据cell模型数据属性执行相应跳转
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = forwardItems![indexPath.row]
        delegate?.didSelectedForwardSaleItem(item)
    }
}



