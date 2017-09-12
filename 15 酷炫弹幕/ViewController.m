//
//  ViewController.m
//  15 酷炫弹幕
//
//  Created by MAC on 2017/8/7.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "ViewController.h"
#import "DGDanMuView.h"
#import "DGImage.h"
#import "DGDanMuModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet DGDanMuView *danMuView;

/**弹幕模型数组*/
@property(nonatomic,strong)NSArray * danMuArr;

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    //加载数据
    [self loadDanMuData];
}


//点击一下屏幕将飘出一条弹幕
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
//     NSString * filePath = [[NSBundle mainBundle]pathForResource:@"弹幕图片01.png" ofType:nil];
//    DGImage * image = [[DGImage alloc]initWithContentsOfFile:filePath];
//    //设置图片从屏幕最右侧飘出
//    image.x = self.view.bounds.size.width;
//    //设置图片飘出时不会出现在DGDanMuView之外
//    image.y = arc4random_uniform(250 - image.size.height);
//    //将这张图片加入到DGDanMuView中
//    [self.danMuView addImages:image];
    
    //----------------------------//
    
    //获得一个随机数值
    NSInteger index = arc4random_uniform((uint32_t)self.danMuArr.count);
    
    //根据随机数值获得弹幕模型
    DGDanMuModel * danMu = self.danMuArr[index];
    
    //根据模型生成图片
   DGImage * image =  [self.danMuView imageWithDanMu:danMu];
    
        //设置图片从屏幕最右侧飘出
        image.x = self.view.bounds.size.width;
        //设置图片飘出时不会出现在DGDanMuView之外
        image.y = arc4random_uniform(250 - image.size.height);
    
    //将这张图片加入到DGDanMuView中
    [self.danMuView addImages:image];
    
}


/**
 控制弹幕是否隐藏

 */
- (IBAction)setUpDanMuHide:(UISwitch *)sender {
    
    [self.danMuView closeDanMu:!sender.on];
    
}

#pragma mark - 加载弹幕数据
-(void)loadDanMuData
{
    //获得文件路径
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"danMu.plist" ofType:nil];
    //根据路径加载数组
    NSArray * array = [NSArray arrayWithContentsOfFile:filePath];
    
    //创建模型数组
    NSMutableArray * danMus = [NSMutableArray array];
    //遍历数组，字典转模型
    for (NSDictionary * dict in array) {
        
        DGDanMuModel * model = [DGDanMuModel danMuWithDict:dict];
        //将模型添加到模型数组
        [danMus addObject:model];
    }
    
//    NSLog(@"%@",danMus);
    
    
    //记录弹幕模型数组
    self.danMuArr = danMus.copy;
    
    
    
}

@end
