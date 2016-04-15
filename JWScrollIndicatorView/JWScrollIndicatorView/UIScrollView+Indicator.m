//
//  UIScrollView+Indicator.m
//  JWScrollIndicatorView
//
//  Created by Vinhome on 16/4/15.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "UIScrollView+Indicator.h"
#import <objc/runtime.h>

@interface JWSlider ()
{
    CGPoint _startCenter;
    UIButton *_sliderIcon;
}
@end

@implementation JWSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
        self.backgroundColor=[UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        _sliderIcon = [UIButton  buttonWithType:UIButtonTypeCustom];
        _sliderIcon.frame=self.bounds;
        [self addSubview:_sliderIcon];
    }
    return self;
}
- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _startCenter = self.center;
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesture translationInView:self];
        self.center = CGPointMake(self.center.x, _startCenter.y + point.y);
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (_status != JWSliderStatusBottom) {
        return;
    }
    
    self.center = CGPointMake(self.center.x, kILSDefaultSliderSize * 0.5);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
}
- (void)setStatus:(JWSliderStatus)status
{
    _status = status;
    
//    switch (status) {
//        case JWSliderStatusTop:
//            _sliderIcon.backgroundColor = [UIColor  redColor];
//            break;
//        case JWSliderStatusCenter:
//            _sliderIcon.backgroundColor = [UIColor  blueColor];
//            break;
//        case JWSliderStatusBottom:
//           _sliderIcon.backgroundColor = [UIColor  blackColor];
//            break;
//        default:
//            break;
//    }
}

@end

@implementation JWIndicatorView

- (void)dealloc
{
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      //  self.backgroundColor=[UIColor orangeColor];
        _slider = [[JWSlider alloc] initWithFrame:CGRectMake(0, 0, kILSDefaultSliderSize, kILSDefaultSliderSize)];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _slider.status = JWSliderStatusTop;
        [self addSubview:_slider];
        self.clipsToBounds = TRUE;
    }
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:0x01 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        float sliderOffsetY = _scrollView.contentOffset.y/(_scrollView.contentSize.height - _scrollView.frame.size.height) * (self.frame.size.height - kILSDefaultSliderSize);
        
        float centerY = sliderOffsetY + kILSDefaultSliderSize * 0.5;
        
        if (centerY <= kILSDefaultSliderSize * 0.5) {
            centerY = kILSDefaultSliderSize * 0.5;
            _slider.status = JWSliderStatusTop;
            
        } else if (centerY >= self.frame.size.height - kILSDefaultSliderSize * 0.5) {
            
            centerY = self.frame.size.height - kILSDefaultSliderSize * 0.5;
            _slider.status = JWSliderStatusBottom;
        } else {
            _slider.status = JWSliderStatusCenter;
        }
        
        _slider.center = CGPointMake(kILSDefaultSliderSize * 0.5, centerY);
    }
//  NSLog(@"_________%f________%f",_slider.center.x,_slider.center.y);
//    if (_scrollView.contentOffset.y > _scrollView.contentSize.height - _scrollView.frame.size.height) {
//        [self infoPanelDidScroll:_scrollView atPoint:CGPointMake(_slider.center.x,_scrollView.contentSize.height-1)];
//    } else {
//        [self infoPanelDidScroll:_scrollView atPoint:_slider.center];
//    }
}
//-(void)infoPanelDidScroll:(UIScrollView*)scrollView atPoint:(CGPoint)point {
//    
//   // NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
//    NSLog(@"_________%f________%f",point.x,point.y);
//}

- (void)sliderValueChanged:(UISlider *)slider
{
    self.value = (slider.center.y - 0.5 * kILSDefaultSliderSize)/(self.frame.size.height - kILSDefaultSliderSize);
    
    self.value = MAX(self.value, 0.0);
    self.value = MIN(self.value, 1.0);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end

@implementation UIScrollView (Indicator)

const char kIndicatorKey;

- (void)setIndicator:(JWIndicatorView *)indicator
{
    objc_setAssociatedObject(self, &kIndicatorKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JWIndicatorView *)indicator
{
    return objc_getAssociatedObject(self, &kIndicatorKey);
}

- (void)registerILSIndicator
{
    if (!self.scrollEnabled || self.contentSize.height <= self.frame.size.height || self.indicator) {
        return;
    }
    
    
    self.showsVerticalScrollIndicator = YES;
    
    JWIndicatorView *indicator = [[JWIndicatorView alloc] initWithFrame:CGRectMake(self.frame.origin.x + self.frame.size.width - kILSDefaultSliderSize, self.frame.origin.y + kILSDefaultSliderMargin, kILSDefaultSliderSize, CGRectGetHeight(self.bounds) - 2 * kILSDefaultSliderMargin)];
    [indicator addTarget:self action:@selector(indicatorValueChanged:) forControlEvents:UIControlEventValueChanged];
    indicator.scrollView = self;
    self.indicator = indicator;
    [self.superview addSubview:indicator];
}


- (void)indicatorValueChanged:(JWIndicatorView *)indicator
{
    float contentOffset = indicator.value * (self.contentSize.height - self.frame.size.height);
   // NSLog(@"_________%f",indicator.value);
    self.contentOffset = CGPointMake(0, contentOffset);
}

@end
