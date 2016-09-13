//
//  BarrageScene.h
//  BarrageKit
//
//  Created by jiachenmu on 16/8/26.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//  弹幕View

#import <UIKit/UIKit.h>

#import "BarrageModel.h"

@class BarrageManager;

@class BarrageScene;

typedef void(^AnimationDidStopBlock)(BarrageScene *scene);

@interface BarrageScene : UIView 

@property (copy, nonatomic) BarrageModel *model;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *voteButton;

@property (copy, nonatomic) AnimationDidStopBlock animationDidStopBlock;

- (void)scroll;

- (void)pause;

- (void)resume;

- (void)close;

- (instancetype)initWithFrame:(CGRect)frame Model:(BarrageModel *)model;

@end
