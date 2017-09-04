//
//  CustomBadgeView.m
//  BSBadge
//
//  Created by Xiongxunquan on 11/27/15.
//  Copyright © 2015 hssdx. All rights reserved.
//

#import "BSBadgeView.h"
#import "UIView+BSBadge.h"

@interface BSBadgeView() <UIGestureRecognizerDelegate>
@property (assign, nonatomic) BOOL drafting;
@property (assign, nonatomic) BOOL leave;
@property (assign, nonatomic) BOOL lockDraw;
@property (assign, nonatomic) CGRect rectInScreen;
@property (assign, nonatomic) CGRect originFrame;
@property (assign, nonatomic) CGPoint handlePoint;
@property (strong, nonatomic) UILabel *badgeLabel;
@property (weak, nonatomic) UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) UIView *gestureView; //is dangerous
@end

@implementation BSBadgeView

- (CGSize)badgeSize {
    return CGSizeMake(self.badgeLength, self.badgeLength);
}

- (CGFloat)badgeLength {
    return self.scale;
}

- (CGSize)smallSize {
    return CGSizeMake(self.hostLength, self.hostLength);
}

- (CGFloat)hostLength {
    return self.badgeLength * 0.4;
}

+ (CGFloat)leaveThreshold {
    return 100;
}

+ (CGFloat)revertThreshold {
    return 20;
}

+ (instancetype)badgeViewWithValue:(NSString *)value {
    BSBadgeView *instance = [[BSBadgeView alloc] initWithValue:value];
    return instance;
}

- (void)removeBadge {
    if (!self.didDismissBlock) {
        return;
    }
    self.didDismissBlock(self);
}

- (void)loadProperty {
    _drafting = NO;
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    CGFloat fontSize = MAX(8, scale);
    fontSize = MIN(18, scale);
    _badgeLabel.font = [UIFont systemFontOfSize:fontSize];
    [self updateBadgeFrame];
}

- (void)updateBadgeFrame {
    [_badgeLabel sizeToFit];
    CGRect frame = _badgeLabel.frame;
    CGFloat width = MAX(frame.size.width + 8, frame.size.height);
    CGSize size = CGSizeMake(width, frame.size.height);
    [self addSubview:_badgeLabel];
    _badgeLabel.layer.masksToBounds = YES;
    [_badgeLabel setBackgroundColor:[UIColor redColor]];
    frame.size = size;
    _badgeLabel.frame = frame;
    _badgeLabel.layer.cornerRadius = frame.size.height * 0.5 + 0.5;
    [_badgeLabel setTextColor:[UIColor whiteColor]];
    [_badgeLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)loadBadgeLabel:(NSString *)value {
    if ([value length] == 0) {
        return;
    }
    _badgeLabel = [UILabel new];
    _badgeLabel.text = value;
    _value = value;
    [self updateBadgeFrame];
}

- (instancetype)initWithValue:(NSString *)value {
    if (self = [super init]) {
        [self loadProperty];
        [self loadBadgeLabel:value];
    }
    return self;
}

#pragma mark - gesture delegate
- (void)loadGestureInView:(UIView *)view {
    UIPanGestureRecognizer *panGesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePanBadge:)];
    self.gestureView = view;
    [self.gestureView addGestureRecognizer:panGesture];
    self.panGesture = panGesture;
}

- (void)loadGestureInSelf {
    [self loadGestureInView:self];
}

- (void)dealloc {
    [_gestureView removeGestureRecognizer:self.panGesture];
}

- (void)expandFrameToScreen {
    CGRect frame = self.frame;
    frame.origin.x = frame.origin.x - self.rectInScreen.origin.x;
    frame.origin.y = frame.origin.y - self.rectInScreen.origin.y;
    frame.size = self.rectInScreen.size;
    self.frame = frame;
}

- (void)recoverFrame {
    CGRect frame = self.originFrame;
    frame.size = [self badgeSize];
    self.frame = frame;
}

- (void)animateDismiss {
    [self.gestureView removeGestureRecognizer:self.panGesture];
    self.lockDraw = YES;
    [self setNeedsDisplay];
    [UIView animateWithDuration:0.2 animations:^{
        self.badgeLabel.transform = CGAffineTransformMakeScale(10, 10);
        self.badgeLabel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeBadge];
            [self.superview bs_dismissBadge];
        }
    }];
}

- (UIView *)rootView {
    NSAssert([NSThread isMainThread], @"%s must in main thread.", __func__);
    static UIView *rootView = nil;
    if (!rootView) {
        rootView = self;
        while (rootView.superview) {
            rootView = rootView.superview;
        }
    }
    return rootView;
}

- (void)handlePanBadge:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            if (!self.drafting) {
                CGRect rectInScreen = [self convertRect:self.bounds toView:self.rootView];
                rectInScreen.size = self.rootView.frame.size;
                self.rectInScreen = rectInScreen;
                self.originFrame = self.frame;
                [self expandFrameToScreen]; //TODO: 在顶层view上绘制，否则会有遮挡
                
                self.drafting = YES;
                self.leave = NO;
            }
            self.handlePoint = CGPointMake(self.rectInScreen.origin.x + translation.x,
                                           self.rectInScreen.origin.y + translation.y);
            [self setNeedsLayout];
            [self setNeedsDisplay];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        {
            if (self.leave) {
                [self animateDismiss];
                return;
            }
            self.drafting = NO;
            self.leave = NO;
            [self recoverFrame];
            [self setNeedsDisplay];
            [self setNeedsLayout];
        }
            break;
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.drafting) {
        CGRect redPointFrame;
        redPointFrame.origin    = self.handlePoint;
        redPointFrame.size      = [self badgeSize];
        CGPoint redPointCenter = CGPointMake(redPointFrame.origin.x + [self badgeLength] * 0.5,
                                             redPointFrame.origin.y + [self badgeLength] * 0.5);
        self.badgeLabel.center = redPointCenter;
    } else {
        self.badgeLabel.center = CGPointMake(0.5 * self.frame.size.width,
                                             0.5 * self.frame.size.height);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.lockDraw) {
        return;
    }
    if (self.drafting) {
        CGRect redPointFrame;
        redPointFrame.origin    = self.handlePoint;
        redPointFrame.size      = [self badgeSize];
        CGPoint redPointCenter = CGPointMake(redPointFrame.origin.x + [self badgeLength] * 0.5,
                                             redPointFrame.origin.y + [self badgeLength] * 0.5);
        
        CGRect hostPointFrame;
        CGFloat offset = 0.5 * ([self badgeLength] - [self hostLength]);
        hostPointFrame.origin   = CGPointMake(self.rectInScreen.origin.x + offset,
                                              self.rectInScreen.origin.y + offset);
        hostPointFrame.size     = [self smallSize];
        CGPoint hostCenter = CGPointMake(hostPointFrame.origin.x + [self hostLength] * 0.5,
                                         hostPointFrame.origin.y + [self hostLength] * 0.5);
        
        CGFloat distance = sqrt((redPointCenter.x - hostCenter.x) * (redPointCenter.x - hostCenter.x) +
                                (redPointCenter.y - hostCenter.y) * (redPointCenter.y - hostCenter.y));
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);

        if (self.leave) {
            if (distance < [self.class revertThreshold]) {
                self.leave = NO;
#if DEBUG
                NSLog(@"回来了");
#endif
            }
        } else  {
            if (distance >= [self.class leaveThreshold]) {
                self.leave = YES;
#if DEBUG
                NSLog(@"离开了");
#endif
            }
        }
        if (NO == self.leave) {
            CGPoint midpoint = CGPointMake((redPointCenter.x + hostCenter.x) * 0.5,
                                           (redPointCenter.y + hostCenter.y) * 0.5);
            
            CGPoint hostPtangencyPoint1 = CGPointZero;
            CGPoint hostPtangencyPoint2 = CGPointZero;
            BOOL success1 = [self.class calculatePtangencyPointCircleCenter:hostCenter
                                                                   outPoint:redPointCenter
                                                                     radius:[self hostLength] * 0.5
                                                            ptangencyPoint1:&hostPtangencyPoint1
                                                            ptangencyPoint2:&hostPtangencyPoint2];
            CGPoint redPointPtangencyPoint1 = CGPointZero;
            CGPoint redPointPtangencyPoint2 = CGPointZero;
            BOOL success2 = NO;
            if (success1) {
                success2 = [self.class calculatePtangencyPointCircleCenter:redPointCenter
                                                                  outPoint:hostCenter
                                                                    radius:[self badgeLength] * 0.5
                                                           ptangencyPoint1:&redPointPtangencyPoint1
                                                           ptangencyPoint2:&redPointPtangencyPoint2];
            }
            if (success1 && success2) {
                /** 移动到 hostPtangencyPoint1
                 *  1 从hostPtangencyPoint1 画弧到 hostPtangencyPoint2
                 *  2 从hostPtangencyPoint2 贝塞尔到 redPointPtangencyPoint2
                 *  3 从redPointPtangencyPoint2 画弧到 redPointPtangencyPoint1
                 *  4 从redPointPtangencyPoint1 贝塞尔到 hostPtangencyPoint1
                 */
                CGContextMoveToPoint(context, hostPtangencyPoint1.x, hostPtangencyPoint1.y);
                CGContextAddLineToPoint(context, hostPtangencyPoint2.x, hostPtangencyPoint2.y);
                CGContextAddQuadCurveToPoint(context, midpoint.x, midpoint.y,
                                             redPointPtangencyPoint2.x, redPointPtangencyPoint2.y);
                CGContextAddLineToPoint(context, redPointPtangencyPoint1.x, redPointPtangencyPoint1.y);
                CGContextAddQuadCurveToPoint(context, midpoint.x, midpoint.y,
                                             hostPtangencyPoint1.x, hostPtangencyPoint1.y);
                CGContextFillPath(context);
            }
            CGContextFillEllipseInRect(context, hostPointFrame);
        }
        CGContextFillEllipseInRect(context, redPointFrame);
    } else {
        CGRect frame = self.frame;
        frame.origin = CGPointZero;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor redColor] set];
        CGContextFillEllipseInRect(context, frame);
    }
}

//@计算圆外点的切点
+ (BOOL)calculatePtangencyPointCircleCenter:(CGPoint)circleCenter
                                   outPoint:(CGPoint)outPoint
                                     radius:(double)radius
                            ptangencyPoint1:(CGPoint *)ptangencyPoint1
                            ptangencyPoint2:(CGPoint *)ptangencyPoint2 {
    double x0 = circleCenter.x;
    double y0 = circleCenter.y;
    double x1 = outPoint.x;
    double y1 = outPoint.y;
    double r2 = radius * radius;
    double d2 = (y1 - y0) * (y1 - y0) + (x1 - x0) * (x1 - x0);
    if (r2 > d2)
    {
        //点在圆心内，没有切线;
        *ptangencyPoint1 = circleCenter;
        *ptangencyPoint2 = circleCenter;
        return NO;
    }
    else if (r2 == d2)
    {
        *ptangencyPoint1 = outPoint;
        *ptangencyPoint2 = outPoint;
        return NO;
    }
    double xRes1 = 0.0;
    double xRes2 = 0.0;
    double yRes1 = 0.0;
    double yRes2 = 0.0;
    if (fabs(y1-y0)<0.00001) {
        xRes1 = circleCenter.x;
        yRes1 = circleCenter.y - radius;
        xRes2 = circleCenter.x;
        yRes2 = circleCenter.y + radius;
    } else {
        assert(y1 != y0);
        double k = (x0 - x1) / (y1 - y0);
        double b = (r2 + (y1 * y1 + x1 * x1 - y0 * y0 - x0 * x0 - d2) / 2.0 ) / (y1 - y0);
        double q = -2.0 * y0;
        double w = -2.0 * x0;
        double v = x0 * x0 + y0 * y0 - r2;
        double a0 = (k * k + 1.0);
        double b0 = (2.0 * k * b + q * k + w);
        double c0 = b * b + q * b + v;
        double dd = b0 * b0 - 4.0 * a0 * c0;
        xRes1 = (-b0 + sqrt(dd)) / (2.0 * a0);
        xRes2 = (-b0 - sqrt(dd)) / (2.0 * a0);
        yRes1 = k * xRes1 + b;
        yRes2 = k * xRes2 + b;
        //验证解 rr2 == r2 ?
        //double rr2 = (xRes1 - x0) * (xRes1 - x0) + (yRes1 - y0) * (yRes1 - y0);
    }
    if (isnan(xRes1) || isnan(xRes2) || isnan(yRes1) || isnan(yRes2)) {
        return NO;
    }
    if (yRes1 > yRes2) //保证yRes1是顶部点
    {
        *ptangencyPoint1 = CGPointMake(xRes2, yRes2);
        *ptangencyPoint2 = CGPointMake(xRes1, yRes1);
    } else {
        *ptangencyPoint1 = CGPointMake(xRes1, yRes1);
        *ptangencyPoint2 = CGPointMake(xRes2, yRes2);
    }
    return YES;
}

@end
