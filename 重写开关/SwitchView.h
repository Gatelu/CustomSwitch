//
//  SwitchView.h
//  重写开关
//
//  Created by Gate on 16/1/9.
//  Copyright © 2016年 Gate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchView : UIControl
@property (nonatomic ,assign) BOOL on;
@property (nonatomic ,strong) UIColor *inactiveColor;
@property (nonatomic ,strong) UIColor *activeColor;
@property (nonatomic ,strong) UIColor *onColor;
@property (nonatomic ,strong) UIColor *borderColor;
@property (nonatomic ,strong) UIColor *knobColor;
@property (nonatomic ,strong) UIColor *shadowColor;
@property (nonatomic ,assign) BOOL isRound;
@property (nonatomic ,strong) UIImage *onImage;
@property (nonatomic ,strong) UIImage *offImage;
- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end
