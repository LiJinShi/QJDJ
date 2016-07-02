//
//  TopItem.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/17.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class HomeItem: NSObject {
    
    // headerView内各模块的高度
    var topViewW: CGFloat {return UIScreen.mainScreen().bounds.width}
    var topViewH: CGFloat {return 180} // 顶部轮播器高度
    var labelBannerH: CGFloat {return 20} // 下面垂直文字轮播器高度
    var functionViewH: CGFloat {return 190} // 功能模块高度
    var margin: CGFloat {return 5} // 功能模块与预售模块间距
    var forwardSaleViewH: CGFloat {return 150} // 预售模块高度
    
    var headerViewH: CGFloat { // 返回headerView的高度
        return topViewH + labelBannerH + functionViewH + margin + forwardSaleViewH
    }
    
    // 底部cell的高度
    var bottomCellH: CGFloat {return 150}
    
    // 提供一个单例来传递数据
    static let shareHomeItem: HomeItem = HomeItem()
    
}
