//
//  TabBarViewController.m
//  BSBadgeDemo
//
//  Created by quanxiong on 16/4/22.
//  Copyright © 2016年 BeachSon. All rights reserved.
//

#import "TabBarViewController.h"
#import "UITabBarController+BSBadge.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bs_setBadge:@"10" remveBadgeBlock:^(BSBadgeView *badgeValue) {
        NSLog(@"已移除气泡");
    } atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
