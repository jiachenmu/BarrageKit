# BarrageKit
ManoBoo所写的一个弹幕小插件
# BarrageKit弹幕插件

标签（空格分隔）： BarrageKit

---

##前言
---
####现在直播这么火，好多直播框架，诸如[IJKMediaFramework](https://github.com/Bilibili/ijkplayer)等更是方便了直播类APP的开发，那我们也一起给它添砖加瓦吧。

##插件介绍
---
插件是基于Objective-C编写的，整体思路较为简单，功能包括：

 1. 弹幕的滚动方向、滚动速度
 2. 弹幕的暂停与恢复、显示与隐藏
 3. 弹幕的类型：纯文字弹幕、投票类弹幕、其他等(可自定义)
 4. 弹幕的推送方式：主动获取弹幕源、被动接收
 5. 弹幕的缓存，避免大量弹幕出现时内存Boom

**还有一些不完善的地方（比如弹幕的轨道现为随机生成，可能会重叠）及一些新的功能欢迎[issue](https://github.com/jiachenmu/BarrageKit/issues)**
##插件展示
---

 - 四个方向的弹幕滚动
  
![四个方向的弹幕滚动](http://i4.buimg.com/567571/7b178d34b7c65e87.gif)

 - 弹幕的暂停与恢复
![弹幕的暂停与恢复](http://i2.piimg.com/567571/3bc4ab4b9a15dc49.gif)
---
##核心代码介绍
---
###①`BarrageManager`弹幕管理者
 **数组介绍：**
- `_cachePool`为弹幕单元的缓冲数组，从屏幕上移除的`BarrageScene`会加入到该数组中
- `_barrageScene`为当前屏幕上正在显示的弹幕显示单元的数组，弹幕显示的时候会加入到该数组中


`BarrageManager` 作为弹幕的管理者，**流程**为：
    
 - 初始化弹幕manager，启动`timer`,主动拉取弹幕数据，调用`-delegate barrageManagerDataSource`返回数据。
 - 调用`- (void)showWithData:(id)data`方法显示弹幕，`data`可以为`BarrageModel`或`NSArray`格式
   - 判断缓冲池是否为空，为空则新建弹幕显示单元`BarrageScene`,并加入到`_barrageScene`数组中。若不为空，则取出`_cachePool`的`firstObject`进行重用并从`_cachePool`中移除，添加到`_barrageScene`中来

### ②`BarrageModel`弹幕模型
####`message`弹幕信息为`NSMutableAttributedString`类型，图片、表情等都可以使用了
**模型属性：**
```
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
```

###③`BarrageScene`弹幕显示单元

- 滚动Scroll
 - ①根据弹幕的滚动速度和滚动方向计算弹幕的滚动距离和所需要的时间
 - ②使用CABasicAnimation完成动画，后期弹幕的暂停和回复比较方便
 - ③弹幕滚动完毕后，执行`_animationDidStopBlock`，将该scene加入到`manager`的`cachePool`中等待被重用

- 重用
 - 弹幕从`BarrageManager`的`cachePool`中取出来，根据`BarrageModel`弹幕信息重新初始化frame且重新开始动画
- 暂停 pause
   - 暂停layer动画即可
  
``` 
CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
self.layer.speed = 0.0;
self.layer.timeOffset = pausedTime;
```

- 恢复 resume
   - 恢复layer动画即可

```
CFTimeInterval pausedTime = [self.layer timeOffset];
self.layer.timeOffset = 0.0;
self.layer.beginTime = 0.0;
self.layer.speed = 1.0;
CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
self.layer.beginTime = timeSincePause;
```


- 关闭 close
```
[self.layer removeAllAnimations];
[self removeFromSuperview];
```

##插件使用
[下载项目]()导入到项目中，使用时`import 'BarrageKit.h'`即可
```
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
```
**Tips:**
- ①如果弹幕为投票类型的弹幕时，请重写`ViewController`的`touchesBegan` 方法
 
```
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
```

- ②重写`ViewController`的`dealloc`方法，执行`BarrageManager`的`toDealloc`
- ③ViewController收到内存警告时，`[_manager didReceiveMemoryWarning];`将会按照`memoryMode`指定的方法清楚缓冲池
```
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // 收到内存警告时，清楚弹幕缓冲池 When you receive a memory warning，clean the barrage's cache
    [_manager didReceiveMemoryWarning];
}
```
- ④如果要高度自定义弹幕显示，可以修改`BarrageScene`中的初始化代码


##最后
###大家查看项目后，欢迎[issue](https://github.com/jiachenmu/BarrageKit/issues)，同时有其他的功能或建议欢迎提出来，简书、github均可。
 - [项目及Demo下载地址](https://github.com/jiachenmu/BarrageKit)
 - ![IOS开发交流群](http://i2.buimg.com/567571/cd9b3c8edd6f164c.png)
