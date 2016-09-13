//
//  BarrageModel.m
//  BarrageKit
//
//  Created by jiachenmu on 16/8/25.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

#import "BarrageModel.h"

@implementation BarrageModel

#pragma mark - initialize(初始化)

- (instancetype)init {
    if (self = [super init]) {
        self.numberID = 0;
        self.message = [[NSMutableAttributedString alloc] initWithString:@""];
        self.author = nil;
        self.object = nil;
    }
    return self;
}

- (instancetype)initWithNumberID:(NSInteger)numID BarrageContent:(NSMutableAttributedString *)message Author:(nullable id)author Object:(nullable id)object {
    BarrageModel *model = [[BarrageModel alloc] init];
    model.numberID = numID;
    model.message = message;
    model.author = author;
    model.object = object;
    
    return model;
}

- (instancetype)initWithNumberID:(NSInteger)numID BarrageContent:(NSMutableAttributedString *)message {
    return [self initWithNumberID:numID BarrageContent:message Author:nil Object:nil];
}

- (instancetype)initWithBarrageContent:(NSMutableAttributedString *)message {
    return [self initWithNumberID:0 BarrageContent:message];
}

@end
