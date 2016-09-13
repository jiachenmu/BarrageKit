//
//  ViewController.m
//  BarrageKit
//
//  Created by jiachenmu on 16/8/25.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

#import "ViewController.h"
#import "BarrageKit.h"


typedef void(^MultiParmsBlock)(NSString *p1, ...);

@interface ViewController () <BarrageManagerDelegate>

@property (strong, nonatomic) BarrageManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 100, 30, 30)];
    [showBtn setImage:[UIImage imageNamed:@"Barrage_close"] forState:UIControlStateNormal];
    [showBtn setImage:[UIImage imageNamed:@"Barrage_show"] forState:UIControlStateSelected];
    [showBtn addTarget:self action:@selector(showBarrage:) forControlEvents:UIControlEventTouchUpInside];
    [showBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:showBtn];
    
    UIButton *pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, self.view.frame.size.height - 100, 30, 30)];
    [pauseBtn setImage:[UIImage imageNamed:@"Barrage_pause"] forState:UIControlStateNormal];
    [pauseBtn setImage:[UIImage imageNamed:@"Barrage_scroll"] forState:UIControlStateSelected];
    [pauseBtn addTarget:self action:@selector(pauseBarrage:) forControlEvents:UIControlEventTouchUpInside];
    [pauseBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:pauseBtn];
    
    _manager = [BarrageManager manager];
    
    //出现的View
    _manager.bindingView = self.view;
    
    //delegate
    _manager.delegate = self;
    
    //弹幕显示位置
    _manager.displayLocation = BarrageDisplayLocationTypeDefault;
    
    //滚动方向
    _manager.scrollDirection = BarrageScrollDirectRightToLeft;
    
    //滚动速度
    _manager.scrollSpeed = 30;
    
    //收到内存警告的处理方式
    _manager.memoryMode = BarrageMemoryWarningModeHalf;
    
    //刷新时间
    _manager.refreshInterval = 1.0;
    
    //开始滚动 manager主动获取弹幕，另外一种方式，`[_manager showBarrageWithDataSource:m]` 退出弹幕即可
    [_manager startScroll];
    
    
    //_manager被动接收弹幕
//    int a = arc4random() % 10000;
//    NSString *str = [NSString stringWithFormat:@"%d 呵呵哒",a];
//    
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
//    [attr addAttribute:NSForegroundColorAttributeName value:RandomColor() range:NSMakeRange(0, str.length)];
//    
//    BarrageModel *m = [[BarrageModel alloc] initWithBarrageContent:attr];
//    m.displayLocation = BarrageDisplayLocationTypeDefault;
//    m.barrageType = BarrageDisplayTypeVote;
    
//    [_manager showBarrageWithDataSource:m];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_manager closeBarrage];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // 收到内存警告时，清楚弹幕缓冲池 When you receive a memory warning，clean the barrage's cache
    [_manager didReceiveMemoryWarning];
}

- (void)dealloc {
    [_manager toDealloc];
}

 UIColor * RandomColor() {
    float a = (arc4random() % 255) / 255.0;
    float b = (arc4random() % 255) / 255.0;
    float c = (arc4random() % 255) / 255.0;
    
    return [UIColor colorWithRed:a green:b blue:c alpha:1.0];
}


#pragma mark - BarrageManagerDelegate
- (id)barrageManagerDataSource {
    
    //演示需要：随机弹幕方向
    int barrageScrollDierct = arc4random() % 4;
    _manager.scrollDirection = (NSInteger)barrageScrollDierct;
    
    //生成弹幕信息
    int a = arc4random() % 10000;
    NSString *str = [NSString stringWithFormat:@"%d 呵呵哒",a];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:RandomColor() range:NSMakeRange(0, str.length)];
    
    BarrageModel *m = [[BarrageModel alloc] initWithBarrageContent:attr];
    m.displayLocation = BarrageDisplayLocationTypeDefault;
    m.barrageType = BarrageDisplayTypeVote;
    return m;
}

- (void)showBarrage:(UIButton *)showBtn {
    showBtn.selected = !showBtn.isSelected;
    [_manager closeBarrage];
}

- (void)pauseBarrage:(UIButton *)pauseBtn{
    pauseBtn.selected = !pauseBtn.isSelected;
    [_manager pauseScroll];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    [[_manager barrageScenes] enumerateObjectsUsingBlock:^(BarrageScene * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layer.presentationLayer hitTest:touchPoint]) {
            //弹幕类型为投票类型时，为弹幕添加点击事件，请在此处添加
            /* if barrage's type is ` BarrageDisplayTypeVote `, add your code here*/
            NSLog(@"message = %@",obj.model.message.string);
        }
    }];
}
@end

