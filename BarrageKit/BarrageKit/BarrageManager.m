//
//  BarrageManager.m
//  BarrageKit
//
//  Created by jiachenmu on 16/8/25.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

#import "BarrageManager.h"

@interface BarrageManager ()

@property (assign, nonatomic) BarrageStatusType currentStatus;

@property (strong, nonatomic) NSMutableArray *cachePool;

@property (strong, nonatomic) NSMutableArray *barrageScene;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation BarrageManager

#pragma mark - create manager(初始化方法)

// singleton 单例
static BarrageManager *instance;
//+ (instancetype)shareManager {
//    static BarrageManager *manager;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[BarrageManager alloc] init];
//    });
//    return manager;
//}

+ (instancetype)shareManager {
    if (!instance) {
        instance = [[BarrageManager alloc] init];
    }
    return instance;
}

+ (instancetype)manager {
    return [[BarrageManager alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollSpeed = BarrageDisplaySpeedTypeDefault;
        _displayLocation = BarrageDisplayLocationTypeDefault;
        _cachePool = [NSMutableArray array];
        _barrageScene = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    [_cachePool removeAllObjects];
    [_barrageScene removeAllObjects];
    NSLog(@"BarrageManager dealloc~");
}

- (NSMutableArray *)barrageCache {
    return _cachePool;
}

- (NSMutableArray<BarrageScene *> *)barrageScenes {
    return _barrageScene;
}

- (void)setRefreshInterval:(NSTimeInterval)refreshInterval {
    _refreshInterval = refreshInterval;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_refreshInterval target:self selector:@selector(buildBarrageScene) userInfo:nil repeats:true];
    [_timer setFireDate:[NSDate distantFuture]];
}


#pragma mark - method(调用方法)
- (void)buildBarrageScene {
    /* build barrage model */
    if (![_delegate  respondsToSelector:@selector(barrageManagerDataSource)]) {
        return;
    }
    id data = [_delegate barrageManagerDataSource];
    if (!data) {
        return;
    }
    [self showWithData:data];
}

- (void)showBarrageWithDataSource:(id)data {
    if (!data) {
        return;
    }
    [self showWithData:data];
}

- (void)showWithData:(id)data {
    /*
     1. determine receiver's type (查看接受对象是否为单个对象或者对象数组)
     2. determine build a new scene OR Taken from the buffer pool inside (查看是否需要新建弹幕)
     */
    _currentStatus = BarrageStatusTypeNormal;
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([data isKindOfClass:[BarrageModel class]]) {
                //only a BarrageModel
                BarrageModel *model = data;
                model = [self sync_BarrageManagerConfigure:model];
                //先查看缓冲池是否为空
                if (_cachePool.count < 1) {
                    // nil
                    BarrageScene *scene = [[BarrageScene alloc] initWithFrame:CGRectZero Model:model];
                    [_barrageScene addObject:scene];
                    [_bindingView addSubview:scene];
                    Weakself;
                    scene.animationDidStopBlock = ^(BarrageScene *scene_){
                        [weakSelf.cachePool addObject:scene_];
                        [weakSelf.barrageScene removeObject:scene_];
                        [scene_ removeFromSuperview];
                    };
                    [scene scroll];
                    
                }else {
                    //从缓冲池获取到Scene后，将其从缓冲池中移除
//                    NSLog(@"get from cache");
                    BarrageScene *scene =  _cachePool.firstObject;
                    [_barrageScene addObject:scene];
                    [_cachePool removeObjectAtIndex:0];
                    scene.model = model;
                    
                    [_bindingView addSubview:scene];
                    [scene scroll];
                }
            }else {
                // more than one barrage
                NSArray <BarrageModel *> *modelArray = data;
                [modelArray enumerateObjectsUsingBlock:^(BarrageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BarrageModel *model = [self sync_BarrageManagerConfigure:obj];
                    //先查看缓冲池是否为空
                    if (_cachePool.count < 1) {
                        // nil
                        BarrageScene *scene = [[BarrageScene alloc] initWithFrame:CGRectZero Model:model];
                        [_barrageScene addObject:scene];
                        [_bindingView addSubview:scene];
                        Weakself;
                        scene.animationDidStopBlock = ^(BarrageScene *scene_){
                            [weakSelf.cachePool addObject:scene_];
                            [weakSelf.barrageScene removeObject:scene_];
                            [scene_ removeFromSuperview];
                        };
                        [scene scroll];
                        
                    }else {
                        //从缓冲池获取到Scene后，将其从缓冲池中移除
                        //                    NSLog(@"get from cache");
                        BarrageScene *scene =  _cachePool.firstObject;
                        [_barrageScene addObject:scene];
                        [_cachePool removeObjectAtIndex:0];
                        scene.model = model;
                        
                        [_bindingView addSubview:scene];
                        [scene scroll];
                    }
                }];
            }
        });
    }
}

-(BarrageModel *) sync_BarrageManagerConfigure:(BarrageModel *)model {
    model.speed = _scrollSpeed;
    model.direction = _scrollDirection;
    model.bindView = _bindingView;
    return model;
}

#pragma mark - Barrage Scroll / Pause / Cloese

- (void)startScroll {
    [_timer setFireDate:[NSDate date]];
}

- (void)pauseScroll {
    if (_currentStatus == BarrageStatusTypeClose) {
        return;
    }
    if (_currentStatus == BarrageStatusTypeNormal) {
        //将屏幕上的弹幕都暂停下来，并且停止获取新的弹幕
        [_timer setFireDate:[NSDate distantFuture]];

        [self.barrageScenes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BarrageScene *scene = obj;
            [scene pause];
        }];
        _currentStatus = BarrageStatusTypePause;
    }else if (_currentStatus == BarrageStatusTypePause) {
        [_timer setFireDate:[NSDate date]];
        [self.barrageScenes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BarrageScene *scene = obj;
            [scene resume];
        }];
        _currentStatus = BarrageStatusTypeNormal;
    }
}

- (void)closeBarrage {
    if (_currentStatus == BarrageStatusTypeNormal) {
        _currentStatus = BarrageStatusTypeClose;
        [_timer setFireDate:[NSDate distantFuture]];

        [self.barrageScenes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BarrageScene *scene = obj;
            [scene close];
        }];

    }else if (_currentStatus == BarrageStatusTypeClose || _currentStatus == BarrageStatusTypePause) {
        _currentStatus = BarrageStatusTypeNormal;
        [_timer setFireDate:[NSDate date]];
    }
}

- (void)toDealloc {
    
    [_timer invalidate];
    _timer = nil;
    [_cachePool removeAllObjects];
    [_barrageScene removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    switch (_memoryMode) {
        case BarrageMemoryWarningModeHalf:
            [self cleanHalfCache];
            break;
        case BarrageMemoryWarningModeAll:
            [self cleanAllCache];
            break;
        default:
            break;
    }
}

- (void)cleanHalfCache {
    NSRange range = NSMakeRange(0, _cachePool.count / 2);
    [_cachePool removeObjectsInRange:range];
}

- (void)cleanAllCache {
    [_cachePool removeAllObjects];
}

@end
