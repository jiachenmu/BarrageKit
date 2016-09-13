//
//  BarrageScene.m
//  BarrageKit
//
//  Created by jiachenmu on 16/8/26.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "BarrageManager.h"
#import "BarrageScene.h"

@implementation BarrageScene

- (instancetype)initWithModel:(BarrageModel *)model {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Model:(BarrageModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
       self.model = model;
    }
    return self;
}

- (void)dealloc {
//    NSLog(@"scene dealloc");
}

- (void)setupUI {
    // text
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:_titleLabel];
    
    // button
    _voteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    _voteButton.hidden = true;
    _voteButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_voteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_voteButton setTitle:@"Vote" forState:UIControlStateNormal];
    [self addSubview:_voteButton];
}

// 加入到SuperView后 开始滚动
- (void)scroll {

    //计算动画距离、时间   calculate time of scroll barrage
    CGFloat distance = 0.0;
    CGPoint goalPoint = CGPointZero;
    switch (_model.direction) {
        case BarrageScrollDirectRightToLeft:
            distance = CGRectGetWidth(_model.bindView.bounds);
            goalPoint = CGPointMake(-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame));
            break;
        case BarrageScrollDirectLeftToRight:
            distance = CGRectGetWidth(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetWidth(_model.bindView.bounds) + CGRectGetWidth(self.frame), CGRectGetMinY(self.frame));
            break;
        case BarrageScrollDirectBottomToTop:
            distance = CGRectGetHeight(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetMinX(self.frame), -CGRectGetHeight(self.frame));
            break;
        case BarrageScrollDirectTopToBottom:
            distance = CGRectGetHeight(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetMinX(self.frame), CGRectGetHeight(self.frame) + CGRectGetMaxY(_model.bindView.bounds));
            break;
        default:
            break;
    }
    NSTimeInterval time = distance / _model.speed;
    
    CGRect goalFrame = self.frame;
    goalFrame.origin = goalPoint;
        
    // layer执行动画
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    animation.removedOnCompletion = true;
    animation.autoreverses = false;
    animation.fillMode = kCAFillModeForwards;
    
    [animation setToValue:[NSValue valueWithCGPoint:CenterPoint(goalFrame)]];
    [animation setDuration:time];
    [self.layer addAnimation:animation forKey:@"kAnimation_BarrageScene"];
}

- (void)setModel:(BarrageModel *)model {
    _model = model;
    [self calculateFrame];
}

- (void)pause {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

- (void)resume {
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    self.layer.speed = 1.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

- (void)close {
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

#pragma mark - 计算Frame
- (void)calculateFrame {
    /* 1. setup UI (基础UI设置) */
    _titleLabel.attributedText = _model.message;
//    _titleLabel.textColor = _model.textColor;

    /* 2. determine barrage's type  (判断弹幕类型) */
    switch (_model.barrageType) {
        case BarrageDisplayTypeVote:
            // --投票类型--
            [_titleLabel sizeToFit];
            _voteButton.hidden = false;
            [_voteButton sizeToFit];
            CGRect frame = _voteButton.frame;
            frame.origin.x = CGRectGetMaxX(_titleLabel.frame);
            frame.origin.y = CGRectGetMinY(_titleLabel.frame);
            frame.size.height = CGRectGetHeight(_titleLabel.frame);
            _voteButton.frame = frame;
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(_titleLabel.frame) + CGRectGetWidth(_voteButton.frame), CGRectGetHeight(_titleLabel.frame));
            break;
        case BarrageDisplayTypeOther:
            // --其他类型--
            
            break;
        default:
            // --BarrageDisplayTypeDefault--
            _voteButton.hidden = true;
            [_titleLabel sizeToFit];
            self.bounds = _titleLabel.bounds;
            break;
    }
    
    //计算弹幕随机位置
    self.frame = [self calculateBarrageSceneFrameWithModel:_model];
}

//MARK: 随机计算弹幕的Frame
-(CGRect) calculateBarrageSceneFrameWithModel:(BarrageModel *)model {
    CGPoint originPoint;
    CGRect sourceFrame = CGRectZero;
    switch (model.displayLocation) {
        case BarrageDisplayLocationTypeDefault:
            sourceFrame = model.bindView.bounds;
            break;
        case BarrageDisplayLocationTypeTop:
            sourceFrame = CGRectMake(0, 0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds) / 3.0);
            break;
        case BarrageDisplayLocationTypeCenter:
            sourceFrame = CGRectMake(0, CGRectGetHeight(model.bindView.bounds) / 3.0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds) / 3.0);
            break;
        case BarrageDisplayLocationTypeBottom:
            sourceFrame = CGRectMake(0, CGRectGetHeight(model.bindView.bounds) / 3.0 * 2.0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds) / 3.0);
            break;
        default:
            break;
    }
    switch (model.direction) {
        case BarrageScrollDirectRightToLeft:
            originPoint = CGPointMake(CGRectGetMaxX(sourceFrame), RandomBetween(0, CGRectGetHeight(sourceFrame) - CGRectGetHeight(self.bounds)));
            break;
        case BarrageScrollDirectLeftToRight:
            originPoint = CGPointMake(-CGRectGetWidth(self.bounds), RandomBetween(0, CGRectGetHeight(sourceFrame) - CGRectGetHeight(self.bounds)));
            break;
        case BarrageScrollDirectBottomToTop:
            originPoint = CGPointMake(RandomBetween(0, CGRectGetWidth(sourceFrame)), CGRectGetMaxY(sourceFrame) + CGRectGetHeight(self.bounds));
            break;
        case BarrageScrollDirectTopToBottom:
            originPoint = CGPointMake(RandomBetween(0, CGRectGetWidth(sourceFrame)), -CGRectGetHeight(self.bounds));
            break;
        default:
            break;
    }
    
    CGRect frame = self.frame;
    frame.origin = originPoint;
    
    return frame;
}

#pragma mark - AnimatonDelegate

// stop
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        __weak typeof(self) SELF = self;
        
        if (_animationDidStopBlock) {
            _animationDidStopBlock(SELF);
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    if ([_voteButton pointInside:point withEvent:event]) {
        NSLog(@"click~~~");
    }
    return [super hitTest:point withEvent:event];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
}

#pragma mark - Other Method
//随机返回某个区间范围内的值 return a ` float ` Between `smallerNumber ` and ` largerNumber `
float RandomBetween(float smallerNumber, float largerNumber) {
    //设置精确的位数
    int precision = 100;
    //先取得他们之间的差值
    float subtraction = largerNumber - smallerNumber;
    //取绝对值
    subtraction = ABS(subtraction);
    //乘以精度的位数
    subtraction *= precision;
    //在差值间随机
    float randomNumber = arc4random() % ((int)subtraction+1);
    //随机的结果除以精度的位数
    randomNumber /= precision;
    //将随机的值加到较小的值上
    float result = MIN(smallerNumber, largerNumber) + randomNumber;
    //返回结果
    return result;
}

//返回一个Frame的中心点
CGPoint CenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}
@end
