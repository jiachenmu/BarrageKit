//
//  BarrageManager.h
//  BarrageKit
//
//  Created by jiachenmu on 16/8/25.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "BarrageEnum.h"

#import "BarrageModel.h"
#import "BarrageScene.h"


@protocol BarrageManagerDelegate <NSObject>

// 弹幕的数据来源,来源可以是数组或者 <BarrageModel>类型的
// Data Sources of barrage, type can be ` NSArray <BarrageModel *> ` or a BarrageModel
- (id)barrageManagerDataSource;

@end

@interface BarrageManager : NSObject

//  弹幕单例
//  barrage's singleton
+ (instancetype)shareManager;

+ (instancetype)manager;

// 弹幕缓存池，下次可以从中取出来使用     barrage's cache
- (NSMutableArray <BarrageScene *> *)barrageCache;

// 正在屏幕上显示的弹幕
- (NSMutableArray <BarrageScene *> *)barrageScenes;

// 弹幕出现的ViewController,  barrage's ViewController
@property (weak, nonatomic) id <BarrageManagerDelegate> delegate;

// the view of show barrage (显示弹幕的View)
@property (weak, nonatomic) UIView *bindingView;

@property (assign, nonatomic) NSInteger scrollSpeed;

// 获取弹幕的间隔， get barrages on time,
@property (assign, nonatomic) NSTimeInterval refreshInterval;

@property (assign, nonatomic) NSInteger displayLocation;

@property (assign, nonatomic) NSInteger scrollDirection;

// 文字限长
@property (assign, nonatomic) NSInteger textLengthLimit;

// 收到内存警告的清除策略
@property (assign, nonatomic) BarrageMemoryWarningMode memoryMode;

//主动获取弹幕  ,Take the initiative to obtain barrage
- (void)startScroll;

//被动接收弹幕数据，生成弹幕 ,Passive receiving a barrage of data
/* data's type is ` BarrageModel ` or ` NSArray <BarrageModel *> `*/
- (void)showBarrageWithDataSource:(id)data;

// pause or resume barrage
- (void)pauseScroll;

// show or close barrage
- (void)closeBarrage;

// 收到内存警告时，可以清除弹幕缓冲池，也可以清除一半的缓冲池
- (void)didReceiveMemoryWarning;

// 防止内存泄露
- (void)toDealloc;
@end
