//
//  DGDanMuModel.m
//  15 酷炫弹幕
//
//  Created by MAC on 2017/9/9.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "DGDanMuModel.h"

@implementation DGDanMuModel

/**
 字典转模型方法

 @param dict 要转的字典
 @return 模型对象
 */
+(instancetype)danMuWithDict:(NSDictionary*)dict
{
    id obj = [[self alloc]init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}

@end
