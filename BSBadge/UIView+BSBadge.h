//
//  UIView+Badge.h
//  Lighting
//
//  Created by Xiongxunquan on 11/27/15.
//  Copyright © 2015 Kingsoft. All rights reserved.
//

#import "BSBadgeView.h"

@interface UIView (BSBadge)
- (BSBadgeView *)badgeView;
- (void)setBadgeValue:(NSString *)badgeValue;
- (void)dismissBadge;
- (void)addRemoveBadgeTarget:(id)target action:(SEL)action;
@end
