//
//  BarrageModel.h
//  BarrageKit
//
//  Created by jiachenmu on 16/8/25.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//  弹幕Model

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "BarrageEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface BarrageModel : NSObject

//MARK: 弹幕Model属性

//弹幕ID barrage's id
@property (assign, nonatomic) NSInteger numberID;

//弹幕时间 barrage;s time
@property (strong, nonatomic) NSString *time;

//弹幕类型 barrage's type
@property (assign, nonatomic) BarrageDisplayType barrageType;

//弹幕速度 barrage's speed
@property (assign, nonatomic) BarrageDisplaySpeedType speed;

//弹幕滚动方向 barrage's direction
@property (assign, nonatomic) BarrageScrollDirection direction;

//弹幕位置 barage's location
@property (assign, nonatomic) BarrageDisplayLocationType displayLocation;

//弹幕所属的父View  barrage's superView
@property (weak, nonatomic) UIView *bindView;

//弹幕内容 barrage's content
@property (strong, nonatomic, nonnull) NSMutableAttributedString *message;

//弹幕作者 barrage's author
@property (strong, nonatomic, nullable) id author;

//弹幕对象 goal object
@property (strong, nonatomic, nullable) id object;

//弹幕字体 barrage's textfont
@property (copy, nonatomic) UIFont *font;

//弹幕字体颜色 barrage's textColor
@property (copy, nonatomic) UIColor *textColor;

//MARK: 弹幕初始化方法

- (instancetype)initWithNumberID:(NSInteger)numID BarrageContent:(NSMutableAttributedString *)message Author:(nullable id)author Object:(nullable id)object;

- (instancetype)initWithNumberID:(NSInteger)numID BarrageContent:(NSMutableAttributedString *)message;

- (instancetype)initWithBarrageContent:(NSMutableAttributedString *)message;

@end

NS_ASSUME_NONNULL_END