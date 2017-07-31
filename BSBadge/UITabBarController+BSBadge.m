//
//  UITabBarController+BSBadge.m
//  IKSarahah
//
//  Created by quanxiong on 2017/7/28.
//  Copyright © 2017年 com.hssdx. All rights reserved.
//

#import "UITabBarController+BSBadge.h"
#import "UIView+BSBadge.h"

static const NSInteger kBadgeViewTag = 93728;


@implementation _UITabBarController_BADGE
@end


@implementation UITabBarController (BSBadge)

- (UIView *)bs_barItemViewAtIndex:(NSInteger)index {
    UIView *barItemView = [self.tabBar viewWithTag:kBadgeViewTag];
    if (!barItemView) {
        //找到所有的 UITabBarButton
        NSMutableArray<UIView *> *tabBarButtonArray = [NSMutableArray array];
        for (UIView *subView in [self.tabBar subviews]) {
            if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [tabBarButtonArray addObject:subView];
            }
        }
        //排序
        [tabBarButtonArray sortUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
            return [@(obj1.frame.origin.x) compare:@(obj2.frame.origin.x)];
        }];
        UIView *tabBarButton = [tabBarButtonArray objectAtIndex:index];
        for (UIView *subView in [tabBarButton subviews]) {
            if ([subView isKindOfClass:NSClassFromString(@"UIImageView")]) {
                barItemView = subView;
            }
        }
        barItemView.tag = kBadgeViewTag;
    }
    return barItemView;
}

- (void)bs_setBadge:(NSString *)badge remveBadgeBlock:(void(^)(BSBadgeView *))block atIndex:(NSInteger)index {
    UIView *barItemView = [self bs_barItemViewAtIndex:index];
    if (badge == nil) {
        [barItemView dismissBadge];
    } else {
        [barItemView setBadgeValue:badge];
        [barItemView setRemoveBadgeBlock:block];
    }
}

- (void)bs_removeBadgeAtIndex:(NSInteger)index {
    UIView *barItemView = [self bs_barItemViewAtIndex:index];
    [barItemView dismissBadge];
}

@end
