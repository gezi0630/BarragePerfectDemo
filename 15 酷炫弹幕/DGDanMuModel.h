//
//  DGDanMuModel.h
//  15 酷炫弹幕
//
//  Created by MAC on 2017/9/9.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import <UIKit/UIKit.h>

//弹幕类型枚举， 0就是其他人，1就是自己
typedef enum {
    DGDanMuTypeOther,
    DGDanMuTypeMe,
} DGDanMuType;

@interface DGDanMuModel : NSObject


/**弹幕类型*/
@property(nonatomic,assign)DGDanMuType type;
/**用户名*/
@property(nonatomic,copy)NSString * username;
/**文本内容*/
@property(nonatomic,copy)NSString * text;
/**头像*/
@property(nonatomic,strong)UIImage * icon;
/**表情图片名数组*/
@property(nonatomic,strong)NSArray<NSString*> * emotions;

/**
 字典转模型方法
*/
+(instancetype)danMuWithDict:(NSDictionary*)dict;




@end
