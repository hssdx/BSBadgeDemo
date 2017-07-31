//
//  UITabBarController+BSBadge.h
//  IKSarahah
//
//  Created by quanxiong on 2017/7/28.
//  Copyright © 2017年 com.inke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSBadgeView;

@interface UITabBarController (BSBadge)

- (void)bs_setBadge:(NSString *)badge remveBadgeBlock:(void(^)(BSBadgeView *))block atIndex:(NSInteger)index;

- (void)bs_removeBadgeAtIndex:(NSInteger)index;

@end
