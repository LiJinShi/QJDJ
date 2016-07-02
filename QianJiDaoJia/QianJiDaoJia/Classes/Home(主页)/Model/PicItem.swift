//
//  PicItem.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/20.
//  Copyright © 2016年 LJS. All rights reserved.
//  每个cell模型

import UIKit

class PicItem: NSObject {
    var Path: String? // 图片url
    var Title: String?
    var Type: Int = 0 // 一张图为0，三张竖图为2，左二右一为1，新人注册为4
    var Value: String? // 这是要发送给下一个页面的categoryID
    
}
