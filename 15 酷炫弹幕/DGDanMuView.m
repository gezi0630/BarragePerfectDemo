//
//  DGDanMuView.m
//  15 酷炫弹幕
//
//  Created by MAC on 2017/8/7.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "DGDanMuView.h"
#import "DGImage.h"
#import "DGDanMuModel.h"

@interface DGDanMuView()

/**
 图片数组
 */
@property(nonatomic,strong)NSMutableArray * imageArr;

/**定时器*/
@property(nonatomic,strong)CADisplayLink * link;

/**即将删除的图片数组*/
@property(nonatomic,strong)NSMutableArray * deleImageArr;

@end
@implementation DGDanMuView

/**
 是否关闭弹幕
 */
-(void)closeDanMu:(BOOL)yes
{
    self.hidden = yes;
    
}

/**
 根据弹幕模型生成弹幕图片
 */
-(DGImage*)imageWithDanMu:(DGDanMuModel*)danMu
{
    //绘制文字使用的字体
    UIFont * font = [UIFont systemFontOfSize:13];
    
    //间距
    CGFloat marginX = 5;
    //头像的尺寸
    CGFloat iconH = 30;
    CGFloat iconW = iconH;
    
    //表情图片的尺寸
    CGFloat emotioW = 25;
    CGFloat emotionH = emotioW;
    
    //计算用户名占据的实际区域
    CGSize nameSize =  [danMu.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    //用户名字体高度
    CGFloat nameFontH = nameSize.height;
    
    
    //计算内容占据的实际区域
    CGSize textSize =  [danMu.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    //内容字体高度
    CGFloat textFontH = textSize.height;
    
    
    //位图上下文的尺寸
    CGFloat contextH = iconH;
    //位图上下文的宽度 = 头像的宽度 + 1个间距 + 1个间距 + 用户名的宽度 + 1个间距 + 内容的宽度 + 表情的宽度 * 个数 + 1个间距
    CGFloat contextW = iconW + marginX * 2 + nameSize.width + marginX + textSize.width + marginX + danMu.emotions.count * emotioW;
    
    
    CGSize contextSize = CGSizeMake(contextW, contextH);
    
    //开启位图上下文
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0);
    
    //获得位图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //将上下文保存一份到栈中，因为绘制头像时会裁剪点一部分上下文
    CGContextSaveGState(ctx);
    
    //--------------绘制头像-------------//
    //设置头像尺寸
    CGRect iconFrame = CGRectMake(0, 0, iconW, iconH);
    //绘制头像圆形
    CGContextAddEllipseInRect(ctx, iconFrame);
    //超出圆形范围内的内容裁减掉
    CGContextClip(ctx);
    
    UIImage * icon = danMu.type ? [UIImage imageNamed:@"me"] : [UIImage imageNamed:@"other"];
    //绘制头像
    [icon drawInRect:iconFrame];
   
    //------------- 绘制背景图片----------------//
    //将上下文出栈
    CGContextRestoreGState(ctx);
    //绘制背景图片
    CGFloat bgX = iconW + marginX;
    CGFloat bgY = 0;
    CGFloat bgW = contextW - bgX;
    CGFloat bgH = contextH;
    
    danMu.type ? [[UIColor orangeColor] set] : [[UIColor whiteColor] set];
    
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(bgX, bgY, bgW, bgH) cornerRadius:20] fill];
    
    //-----------------绘制用户名---------------//
    CGFloat nameX = bgX + marginX;
    CGFloat nameY = (contextH - nameFontH) * 0.5;
    CGRect nameRect = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    [danMu.username drawInRect:nameRect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName : danMu.type ? [UIColor blackColor] : [UIColor orangeColor]}];
    
    //----------------绘制文本区域 --------------------//
    CGFloat textX = nameX + nameSize.width + marginX;
    CGFloat textY = (contextH - textFontH) * 0.5;
    CGRect textRect = CGRectMake(textX, textY, textSize.width, textSize.height);
    
    [danMu.text drawInRect:textRect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName : danMu.type ? [UIColor whiteColor] : [UIColor blackColor]}];
    
    //----------------绘制表情图片 --------------------//
   __block CGFloat emotionX = textX + textSize.width;
    CGFloat emotionY = (contextH - emotionH) * 0.5;
    
    [danMu.emotions enumerateObjectsUsingBlock:^(NSString * _Nonnull emotionName, NSUInteger idx, BOOL * _Nonnull stop) {
       
        //加载表情图片
        UIImage * emotion = [UIImage imageNamed:emotionName];
        
        [emotion drawInRect:CGRectMake(emotionX, emotionY, emotioW, emotionH)];
        
        emotionX += emotioW;
        
        
    }];
    
    //从位图上下文获得绘制好的图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    //根据屏幕比例返回这张图片
    return [[DGImage alloc]initWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

-(void)addImages:(DGImage*)image
{
    //将图片加入的数组中
    [self.imageArr addObject:image];
    
    [self addTimer];
    
}

- (void)drawRect:(CGRect)rect {
    
   //当图片数组中没有图片是就销毁定时器
if (self.imageArr.count == 0) {
        [self.link invalidate];
            self.link = nil;
        return;
}

    
//    NSLog(@"%s",__func__);
     //从图片数组中不断读取图片
    for (DGImage * image in self.imageArr) {
        
        //让图片的x值不断变小，在水平方向就会向左飘去
        image.x -= 3;
        
        //绘制图片，如果定时器不停止这里就会不断绘制
         [image drawAtPoint:CGPointMake(image.x, image.y)];
        
        //当图片的最右侧飘离屏幕时，就把这张图片添加到即将删除的数组中
        if (image.x + image.size.width < 0) {
            
            [self.deleImageArr addObject:image];
            
        }
        
        
        
}

    //因为不能一边遍历数组一边从这个数组中删除元素，所以只能从deleImageArr中遍历出这个图片然后从imageArr中删除
    for (DGImage * image in self.deleImageArr) {
        
        [self.imageArr removeObject:image];
        
    }

    [self.deleImageArr removeAllObjects];
    

    
}


#pragma mark - 添加定时器
-(void)addTimer
{
    if (self.link) return;
    
    CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes ];
    
    self.link = link;
    
}

#pragma mark - 懒加载图片数组
-(NSMutableArray*)imageArr
{
    
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

-(NSMutableArray*)deleImageArr
{
    
    if (_deleImageArr == nil) {
        _deleImageArr = [NSMutableArray array];
    }
    return _deleImageArr;
}


@end
