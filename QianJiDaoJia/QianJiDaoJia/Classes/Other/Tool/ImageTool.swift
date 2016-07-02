//
//  ImageTool.swift
//  QianJiDaoJia
//
//  Created by Macx on 16/6/16.
//  Copyright © 2016年 LJS. All rights reserved.
//

import UIKit

class ImageTool: NSObject {
    
    /**
     传入一张图片,得到一张新尺寸图片
     
     - parameter image: 原始图片
     - parameter size:  希望得到图片的大小(size)
     
     - returns: 得到新的尺寸的原始图片
     */
    class func OriginImage(image: UIImage, size: CGSize) -> (UIImage) {
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage.imageWithRenderingMode(.AlwaysOriginal) // 返回不渲染的图片
    }

    /**
     传入颜色值生成纯色图片
     
     - parameter color: 传入rgb颜色
     - parameter size:  传入想要生成图片尺寸
     
     - returns: 生成的图片
     */
    class func creatImageWithColor(color: UIColor, size: CGSize) -> (UIImage) {
        
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        CGContextFillRect(context, rect);
        let theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return theImage
    }
    
    /**
     将传入图片剪切为圆角
     
     - parameter image: 传入的图片
     
     - returns: 返回的图片
     */
    class func getCutImage(image: UIImage) -> (UIImage) {
        // 开启一个图形上下文
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0);
        // 描述裁剪区域
        let clipPath = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        // 设置裁剪区域
        clipPath.addClip()
        // 画图
        image.drawAtPoint(CGPointZero)
        // 取出图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return newImage
    }
}



