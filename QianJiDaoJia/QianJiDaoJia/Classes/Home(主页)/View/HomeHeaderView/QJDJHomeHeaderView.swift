//
//  QJDJHomeHeaderView.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/18.
//  Copyright © 2016年 LJS. All rights reserved.
//  主页HeaderView

import UIKit

// 利用代理协议来监听各模块的点击事件，最终传到外面的控制器处理跳转
protocol QJDJHomeHeaderViewDelegate: QJDJHeaderTopViewDelegate,QJDJFunctionViewDelegate,QJDJForwardSaleViewDelegate {
    
}

class QJDJHomeHeaderView: UIView {
    weak var delegate: QJDJHomeHeaderViewDelegate? { // 将本模块的代理传递到子模块
        willSet {
            functionView.delegate = newValue
            forwardSaleView.delegate = newValue
            topV.delegate = newValue
        }
    }
    
    // 懒加载属性
    // 添加HeaderTopView 
    lazy var topV: QJDJHeaderTopView = {
        let topW = HomeItem.shareHomeItem.topViewW
        let topH: CGFloat = HomeItem.shareHomeItem.topViewH
        let topRect = CGRect(x: 0, y: 0, width: topW, height: topH)
        let topV = QJDJHeaderTopView(frame: topRect)
        return topV
    }()
    
    // 添加LabelBanner(垂直的文字轮播)
    lazy var labelBanner: QJDJLabelBanner = {
        let labelBannerH = HomeItem.shareHomeItem.labelBannerH
        let labelBannerW = HomeItem.shareHomeItem.topViewW
        let labelBannerY = CGRectGetMaxY(self.topV.frame)
        let labelBannerRect = CGRect(x: 0, y: labelBannerY, width: labelBannerW, height: labelBannerH)
        let labelBanner = QJDJLabelBanner(frame: labelBannerRect)
        return labelBanner
    }()
    
    // 添加FunctionView模块
    lazy var functionView: QJDJFunctionView = {
        let functionY: CGFloat = CGRectGetMaxY(self.labelBanner.frame)
        let functionH = HomeItem.shareHomeItem.functionViewH
        let functionW = HomeItem.shareHomeItem.topViewW
        let functionRect = CGRect(x: 0, y: functionY, width: functionW, height: functionH)
        let functionView = QJDJFunctionView(frame: functionRect)
        return functionView
    }()
    
    // 添加预售(forwardSale)模块
    lazy var forwardSaleView: QJDJForwardSaleView = {
        // 添加预售(forwardSale)模块
        let forwardY = CGRectGetMaxY(self.functionView.frame) + HomeItem.shareHomeItem.margin
        let forwardH = HomeItem.shareHomeItem.forwardSaleViewH
        let forwardW =  HomeItem.shareHomeItem.topViewW
        let forwardRect = CGRect(x: 0, y: forwardY, width: forwardW, height: forwardH)
        let forwardSaleView = QJDJForwardSaleView(frame: forwardRect)
        return forwardSaleView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(topV)
        addSubview(labelBanner)
        addSubview(functionView)
        addSubview(forwardSaleView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

