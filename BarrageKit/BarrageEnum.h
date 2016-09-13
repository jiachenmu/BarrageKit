//
//  BarrageEnum.h
//  BarrageKit
//
//  Created by jiachenmu on 16/8/29.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

#ifndef BarrageEnum_h
#define BarrageEnum_h

#define Weakself __weak typeof(self) weakSelf = self

typedef NS_ENUM(NSInteger, BarrageStatusType) {
    BarrageStatusTypeNormal = 0,
    BarrageStatusTypePause,
    BarrageStatusTypeClose,
};

// 弹幕的滚动速度,单位为秒
// scroll speed of barrage,in seconds
typedef NS_ENUM(NSInteger, BarrageDisplaySpeedType) {
    BarrageDisplaySpeedTypeDefault = 10,
    BarrageDisplaySpeedTypeFast = 20,
    BarrageDisplaySpeedTypeFaster = 40,
    BarrageDisplaySpeedTypeMostFast = 60,
};

//  弹幕滚动的方向
typedef NS_ENUM(NSInteger, BarrageScrollDirection) {
    BarrageScrollDirectRightToLeft = 0,     /*  <<<<<   */
    BarrageScrollDirectLeftToRight = 1,     /*  >>>>>   */
    BarrageScrollDirectBottomToTop = 2,     /*  ↑↑↑↑   */
    BarrageScrollDirectTopToBottom = 3,     /*  ↓↓↓↓   */
};

// 弹幕显示的位置  `default` 为页面全局
// location of barrage, `default` is global page
typedef NS_ENUM(NSInteger, BarrageDisplayLocationType) {
    BarrageDisplayLocationTypeDefault = 0,
    BarrageDisplayLocationTypeTop = 1,
    BarrageDisplayLocationTypeCenter = 2,
    BarrageDisplayLocationTypeBottom = 3,
    BarrageDisplayLocationTypeHidden,
};

//  弹幕的类型
//  type of barrage
typedef NS_ENUM(NSInteger, BarrageDisplayType) {
    BarrageDisplayTypeDefault = 0,  /* only text (纯文字弹幕)    */
    BarrageDisplayTypeVote,         /* text and vote(文字加投票) */
    BarrageDisplayTypeOther,        /* other                    */
};

// 收到内存警告的清除策略
typedef NS_ENUM(NSInteger, BarrageMemoryWarningMode) {
    BarrageMemoryWarningModeHalf = 0, //清除一半
    BarrageMemoryWarningModeAll,       //清空缓冲池
};
#endif /* BarrageEnum_h */
