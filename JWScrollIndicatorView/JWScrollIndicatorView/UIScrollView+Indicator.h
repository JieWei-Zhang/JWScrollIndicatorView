//
//  UIScrollView+Indicator.h
//  JWScrollIndicatorView
//
//  Created by Vinhome on 16/4/15.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

const static NSInteger kILSDefaultSliderSize = 40;
const static NSInteger kILSDefaultSliderMargin = 20;

typedef enum {
    
    JWSliderStatusTop,
    JWSliderStatusCenter,
    JWSliderStatusBottom
    
} JWSliderStatus;

@interface JWSlider : UIControl

@property (nonatomic, assign) JWSliderStatus status;
@property (nonatomic, strong) UIButton* sliderIcon;


@end

@interface JWIndicatorView : UIControl

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) JWSlider *slider;
@property (nonatomic, assign) float value;

@end
@interface UIScrollView (Indicator)
@property (nonatomic, strong) JWIndicatorView *indicator;
- (void)registerILSIndicator;
-(void)infoPanelDidScroll:(UIScrollView*)scrollView atPoint:(CGPoint)point;
@end
