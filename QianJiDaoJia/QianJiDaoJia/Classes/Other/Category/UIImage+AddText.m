//
//  UIImage+AddText.m
//  QianJiDaoJia
//
//  Created by Macx on 16/6/18.
//  Copyright © 2016年 LJS. All rights reserved.
//

#import "UIImage+AddText.h"

@implementation UIImage (AddText)
/**
 *  在图片上添加文字(添加文字水印)
 *
 *  @param image 图片
 *  @param text1 文字
 *  @param point 要将文字添加到图片的哪个位置
 *
 *  @return 返回一张添加了文字的图片
 */
- (UIImage *)addText:(UIImage *)image text:(NSString *)text1 atPoint:(CGPoint)point
{
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    
    //生成图片(要开启一个位图上下文)
    UIGraphicsBeginImageContext(image.size);
    //把图片绘制到上下文当中
    [image drawAtPoint:CGPointZero];
    //把文字绘制到上下文当中
    [text1 drawAtPoint:point withAttributes:att];
    //从上下文当中生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

@end
