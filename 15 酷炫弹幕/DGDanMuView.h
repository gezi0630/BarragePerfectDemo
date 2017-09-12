//
//  DGDanMuView.h
//  15 酷炫弹幕
//
//  Created by MAC on 2017/8/7.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DGImage,DGDanMuModel;

@interface DGDanMuView : UIView


/**
 添加弹幕图片

 */
-(void)addImages:(DGImage*)image;


/**
 根据弹幕模型生成弹幕图片
 */
-(DGImage*)imageWithDanMu:(DGDanMuModel*)danMu;


/**
 是否关闭弹幕
 */
-(void)closeDanMu:(BOOL)yes;


@end
