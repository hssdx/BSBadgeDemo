//
//  CustomBadgeView.h
//  BSBadge
//
//  Created by Xiongxunquan on 11/27/15.
//  Copyright © 2015 hssdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSBadgeView : UIView
@property (copy, nonatomic) NSString *value;
@property (assign, nonatomic) CGFloat scale;
@property (copy, nonatomic) void (^didDismissBlock)(BSBadgeView *view);

+ (instancetype)badgeViewWithValue:(NSString *)value;
- (CGFloat)badgeLength;
- (void)loadGestureInView:(UIView *)view;
- (void)loadGestureInSelf;
@end
