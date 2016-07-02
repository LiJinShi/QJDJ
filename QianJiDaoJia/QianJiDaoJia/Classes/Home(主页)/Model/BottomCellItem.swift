//
//  BottomCellItem.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/19.
//  Copyright © 2016年 LJS. All rights reserved.
//  最外层模型

import UIKit
import MJExtension

class BottomCellItem: NSObject {
    
    var PicArray: [PicItem]? // 里面是一个图或3个图的模型
    var PicType: Int = 0 // 为1时是1张图，为3是3张竖图，为4是左边两张，右边一张
    
    override class func mj_objectClassInArray() -> [NSObject : AnyObject]! {
        return ["PicArray" : PicItem.classForCoder()]
    }
}
