//
//  TabBarViewController.m
//  BSBadgeDemo
//
//  Created by quanxiong on 16/4/22.
//  Copyright © 2016年 BeachSon. All rights reserved.
//

#import "TabBarViewController.h"
#import "UIView+BSBadge.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUnreadEdge:@10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)edgeViewTag {
    return 12345;
}

- (void)updateUnreadEdge:(NSNumber *)unreadCount {
    UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    UIView *imageView = [self.tabBar viewWithTag:self.edgeViewTag];
    if (!imageView) {
        //找最左的 UITabBarButton
        UIView *tabBarButton;
        for (UIView *subView in [self.tabBar subviews]) {
            if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                if (!tabBarButton) {
                    tabBarButton = subView;
                } else {
                    if (tabBarButton.frame.origin.x > subView.frame.origin.x) {
                        tabBarButton = subView;
                    }
                }
            }
        }
        for (UIView *subView in [tabBarButton subviews]) {
            if ([subView isKindOfClass:NSClassFromString(@"UIImageView")]) {
                imageView = subView;
            }
        }
        imageView.tag = self.edgeViewTag;
    }
    if (unreadCount.intValue == 0) {
        [imageView dismissBadge];
        if (types != UIUserNotificationTypeNone) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    } else {
        if (types != UIUserNotificationTypeNone) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount.integerValue;
        }
        [imageView setBadgeValue:unreadCount.stringValue];
        [imageView addRemoveBadgeTarget:self action:@selector(didRemoveBadge:)];
    }
}

- (void)didRemoveBadge:(id)sender {
    NSLog(@"%s", __func__);
}

@end
