//
//  FirstViewController.m
//  BarrageKit
//
//  Created by jiachenmu on 16/9/1.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"

@interface FirstViewController ()

@property (strong, nonatomic) NSString *str;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)startBarrage:(id)sender {
    [self.navigationController pushViewController:[[ViewController alloc] init] animated:true];
}

@end

