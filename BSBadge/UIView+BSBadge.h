//
//  UIView+Badge.h
//  Lighting
//
//  Created by Xiongxunquan on 11/27/15.
//  Copyright © 2015 hssdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSBadgeView;


@interface _UIView_BADGE : NSObject
@end


@interface UIView (BSBadge)
- (BSBadgeView *)badgeView;
- (void)setBadgeValue:(NSString *)badgeValue;
- (void)dismissBadge;
- (void)setRemoveBadgeBlock:(void(^)(BSBadgeView *))block;
@end
