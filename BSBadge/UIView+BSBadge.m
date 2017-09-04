//
//  UIView+Badge.m
//  BSBadge
//
//  Created by Xiongxunquan on 11/27/15.
//  Copyright © 2015 hssdx. All rights reserved.
//

#import "UIView+BSBadge.h"
#import "BSBadgeView.h"
#import <objc/runtime.h>

#pragma mark - kvc
static const char s_bubbleBadgeView;


@interface _UIView_BADGE : NSObject
@end

@implementation _UIView_BADGE
@end

@implementation UIView (BSBadge)

- (void)bs_setBadgeView:(BSBadgeView *)badgeView offset:(CGPoint)offset scale:(CGFloat)scale {
    if (badgeView != self.bs_badgeView) {
        // 删除旧的，添加新的
        [self.bs_badgeView removeFromSuperview];
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
        objc_setAssociatedObject(self, &s_bubbleBadgeView,
                                 badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"badgeView"]; // KVO
    }
}

- (void)bs_setBadgeView:(BSBadgeView *)badgeView {
    [self bs_setBadgeView:badgeView offset:CGPointMake(0, 0) scale:20];
}

- (BSBadgeView *)bs_badgeView {
    return objc_getAssociatedObject(self, &s_bubbleBadgeView);
}

- (void)bs_setBadgeValue:(NSString *)badgeValue {
    if (badgeValue.length == 0) {
        [self bs_setBadgeValue:badgeValue offset:CGPointMake(-4, -2) scale:6 gestureInView:self.superview needGesture:NO];
    } else {
        [self bs_setBadgeValue:badgeValue offset:CGPointMake(-2, -8) scale:13 gestureInView:self.superview needGesture:YES];
    }
}

- (void)bs_setBadgeValue:(NSString *)badgeValue
               offset:(CGPoint)offset
                scale:(CGFloat)scale
        gestureInView:(UIView *)view
          needGesture:(BOOL)needGesture {
    BSBadgeView *badgeView = [BSBadgeView badgeViewWithValue:badgeValue];
    [self bs_setBadgeView:badgeView offset:offset scale:scale];
    if (needGesture) {
        if (view) {
            [badgeView loadGestureInView:view];
        } else {
            [badgeView loadGestureInSelf];
        }
    }
}

- (void)bs_dismissBadge {
    [self bs_setBadgeView:nil];
}

- (void)bs_setRemoveBadgeBlock:(void(^)(BSBadgeView *))block {
    self.bs_badgeView.didDismissBlock = block;
}

@end
