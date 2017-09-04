//
//  UIView+Badge.h
//  BSBadge
//
//  Created by Xiongxunquan on 11/27/15.
//  Copyright © 2015 hssdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSBadgeView;

@interface UIView (BSBadge)

- (BSBadgeView *)bs_badgeView;
- (void)bs_setBadgeValue:(NSString *)badgeValue;
- (void)bs_dismissBadge;
- (void)bs_setRemoveBadgeBlock:(void(^)(BSBadgeView *))block;

@end
