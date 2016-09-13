//
//  FirstViewController.h
//  BarrageKit
//
//  Created by jiachenmu on 16/9/1.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@end

@interface Person : NSObject

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSString *age;

@end

@interface Son : Person

@end