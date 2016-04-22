//
//  UIView+Badge.m
//  Lighting
//
//  Created by Xiongxunquan on 11/27/15.
//  Copyright © 2015 Kingsoft. All rights reserved.
//

#import "UIView+BSBadge.h"
#import "BSBadgeView.h"
#import <objc/runtime.h>

#pragma mark - kvc
static const char CustomBubbleBadgeView = '\0';

@implementation UIView (BSBadge)

- (void)setBadgeView:(BSBadgeView *)badgeView offset:(CGPoint)offset scale:(CGFloat)scale {
    if (badgeView != self.badgeView) {
        // 删除旧的，添加新的
        [self.badgeView removeFromSuperview];
        if (badgeView) {
            [self addSubview:badgeView];
            // 约束
            badgeView.scale = scale;
            CGRect frame = self.bounds;
            frame.size.width = scale;
            frame.size.height = scale;
            frame.origin.x = offset.x + self.frame.size.width;
            frame.origin.y = offset.y;
            badgeView.frame = frame;
        }
        // 存储新的
        [self willChangeValueForKey:@"badgeView"]; // KVO
        objc_setAssociatedObject(self, &CustomBubbleBadgeView,
                                 badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"badgeView"]; // KVO
    }
}

- (void)setBadgeView:(BSBadgeView *)badgeView {
    [self setBadgeView:badgeView offset:CGPointMake(0, 0) scale:20];
}

- (BSBadgeView *)badgeView {
    return objc_getAssociatedObject(self, &CustomBubbleBadgeView);
}

- (void)setBadgeValue:(NSString *)badgeValue {
    [self setBadgeValue:badgeValue offset:CGPointMake(0, -6) scale:20 gestureInView:self.superview needGesture:YES];
}

- (void)setBadgeValue:(NSString *)badgeValue
               offset:(CGPoint)offset
                scale:(CGFloat)scale
        gestureInView:(UIView *)view
          needGesture:(BOOL)needGesture {
    BSBadgeView *badgeView = [BSBadgeView badgeViewWithValue:badgeValue];
    [self setBadgeView:badgeView offset:offset scale:scale];
    if (needGesture) {
        if (view) {
            [badgeView loadGestureInView:view];
        } else {
            [badgeView loadGestureInSelf];
        }
    }
}

- (void)dismissBadge {
    [self setBadgeView:nil];
}

- (void)addRemoveBadgeTarget:(id)target action:(SEL)action {
    self.badgeView.target = target;
    self.badgeView.action = action;
}

@end
