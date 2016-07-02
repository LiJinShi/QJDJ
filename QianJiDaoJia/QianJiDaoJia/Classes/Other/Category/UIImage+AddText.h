//
//  UIImage+AddText.h
//  QianJiDaoJia
//
//  Created by Macx on 16/6/18.
//  Copyright © 2016年 LJS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AddText)
/**
 *  在图片上添加文字(添加文字水印)
 *
 *  @param image 图片
 *  @param text1 文字
 *  @param point 要将文字添加到图片的哪个位置
 *
 *  @return 返回一张添加了文字的图片
 */
-(UIImage *)addText:(UIImage *)image text:(NSString *)text1 atPoint:(CGPoint)point;
@end
