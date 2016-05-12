//
//  SwitchView.m
//  重写开关
//
//  Created by Gate on 16/1/9.
//  Copyright © 2016年 Gate. All rights reserved.
//

#import "SwitchView.h"
@interface SwitchView()
@property (nonatomic ,strong)UIView *background;
@property (nonatomic ,strong)UIView *knob;
@property (nonatomic ,strong)UIImageView *onImageView;
@property (nonatomic ,strong)UIImageView *offImageView;
@property (nonatomic ,assign) double startTime;
@property (nonatomic ,assign) BOOL isAnimating;
- (void)showOn:(BOOL)animated;
- (void)showOff:(BOOL)animated;
- (void)setup;
@end

@implementation SwitchView

- (instancetype)init{
    if (self = [super init]) {
        self = [self initWithFrame:CGRectMake(0, 0, 50, 30)];
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, 0, 50, 30);
    }else{
        initialFrame = frame;
    }
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.on = NO;
    self.isRound = YES;
    self.inactiveColor = [UIColor clearColor];
    self.activeColor = [UIColor colorWithRed:1.000 green:0.944 blue:0.038 alpha:1.000];
    self.onColor = [UIColor greenColor];
    self.borderColor = [UIColor orangeColor];
    self.knobColor = [UIColor colorWithRed:0.159 green:1.000 blue:0.912 alpha:1.000];
    self.shadowColor = [UIColor colorWithRed:0.982 green:0.231 blue:1.000 alpha:1.000];
    self.background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _background.backgroundColor = [UIColor clearColor];
    _background.layer.cornerRadius = self.frame.size.height / 2;
    _background.layer.borderColor = self.borderColor.CGColor;
    _background.layer.borderWidth = 1;
    _background.userInteractionEnabled = NO;
    [self addSubview:_background];
    
    //imageView
    _onImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    _onImageView.alpha = 0;
    _onImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_onImageView];
    
    _offImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.height, 0,self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    _offImageView.alpha = 1.0;
    _offImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_offImageView];
    
    //konb
    self.knob = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.height - 2, self.frame.size.height - 2)];
    self.knob.backgroundColor = self.knobColor;
    self.knob.layer.cornerRadius = (self.frame.size.height / 2) - 1;
    self.knob.layer.shadowColor = self.shadowColor.CGColor;
    self.knob.layer.cornerRadius = 2.0;
    self.knob.layer.shadowOpacity = 0.5;
    self.knob.layer.shadowOffset = CGSizeMake(0, 3);
    self.knob.layer.masksToBounds = NO;
    self.knob.userInteractionEnabled = NO;
    [self addSubview:_knob];
    _isAnimating = NO;
    
}
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    _startTime = [[NSDate date] timeIntervalSince1970];
    CGFloat activeKnobWidth = self.bounds.size.height + 3;
    _isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (self.on) {
            _knob.frame = CGRectMake(self.frame.size.width - (activeKnobWidth + 1), _knob.frame.origin.y, activeKnobWidth, _knob.frame.size.height);
            _background.backgroundColor = self.onColor;
        }else{
            _knob.frame = CGRectMake(_knob.frame.origin.x, _knob.frame.origin.y, activeKnobWidth, _knob.frame.size.height);
            _background.backgroundColor = self.activeColor;
        }
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint lastPoint = [touch locationInView:self];
    if (lastPoint.x > self.bounds.size.width / 2) {
        [self showOn:YES];
    }else{
        [self showOff:YES];
    }
    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    double endTime = [[NSDate date] timeIntervalSince1970];
    double difference = endTime - _startTime;
    BOOL previousValue = self.on;
    if (difference <= 0.2) {
        CGFloat normalKnobWidth = self.bounds.size.height - 2;
        _knob.frame = CGRectMake(_knob.frame.origin.x, _knob.frame.origin.y, normalKnobWidth, _knob.frame.size.height);
        [self setOn:!self.on animated:YES];
    }else{
        CGPoint lastPoint = [touch locationInView:self];
        
        // update the switch to the correct value depending on if
        // their touch finished on the right or left side of the switch
        if (lastPoint.x > self.bounds.size.width * 0.5)
            [self setOn:YES animated:YES];
        else
            [self setOn:NO animated:YES];
    }
    if (previousValue != self.on)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    
    // just animate back to the original value
    if (self.on)
        [self showOn:YES];
    else
        [self showOff:YES];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_isAnimating) {
        CGRect frame = self.frame;
        
        // background
        _background.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _background.layer.cornerRadius = self.isRound ? frame.size.height * 0.5 : 2;
        
        // images
        _onImageView.frame = CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height);
        _offImageView.frame = CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height);
        
        // knob
        CGFloat normalKnobWidth = frame.size.height - 2;
        if (self.on)
            _knob.frame = CGRectMake(frame.size.width - (normalKnobWidth + 1), 1, frame.size.height - 2, normalKnobWidth);
        else
            _knob.frame = CGRectMake(1, 1, normalKnobWidth, normalKnobWidth);
        
        _knob.layer.cornerRadius = self.isRound ? (frame.size.height * 0.5) - 1 : 2;
    }
}

/**
 *  重写set方法
 */
- (void)setInactiveColor:(UIColor *)inactiveColor{
    _inactiveColor = inactiveColor;
    if (!self.on && !self.isTracking) {
        _background.backgroundColor = inactiveColor;
    }
}
- (void)setOnColor:(UIColor *)onColor{
    _onColor = onColor;
    if (self.on && self.isTracking) {
        _background.backgroundColor = onColor;
        _background.layer.borderColor = onColor.CGColor;
    }
}
- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    if (!self.on) {
        _background.layer.borderColor = borderColor.CGColor;
    }
}
- (void)setKnobColor:(UIColor *)knobColor{
    _knobColor = knobColor;
    _knob.backgroundColor = knobColor;
}
- (void)setShadowColor:(UIColor *)shadowColor{
    _shadowColor = shadowColor;
    _knob.layer.shadowColor = shadowColor.CGColor;
}
- (void)setOnImage:(UIImage *)onImage{
    _onImage = onImage;
    _onImageView.image = onImage;
}
- (void)setOffImage:(UIImage *)offImage{
    _offImage = offImage;
    _offImageView.image = offImage;
}
-(void)setIsRound:(BOOL)isRound{
    _isRound = isRound;
    if (isRound) {
        _background.layer.cornerRadius = self.frame.size.height / 2;
        _knob.layer.cornerRadius = (self.frame.size.height / 2) - 1;
    }else{
        self.background.layer.cornerRadius = 2;
        self.knob.layer.cornerRadius = 2;
    }
}
- (void)setOn:(BOOL)on{
    [self setOn:on animated:NO];
}
- (void)setOn:(BOOL)on animated:(BOOL)animated{
    _on = on;
    if (on) {
        [self showOn:YES];
    }else{
        [self showOff:YES];
    }
}
/**
 *  重写get方法
 */

- (BOOL)isOn{
    return self.on;
}
#pragma mark State Changes

- (void)showOn:(BOOL)animated{
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.isTracking) {
                _knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), _knob.frame.origin.y, activeKnobWidth, _knob.frame.size.height);
            }else
                _knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), _knob.frame.origin.y, normalKnobWidth, _knob.frame.size.height);
            
            _background.backgroundColor = self.onColor;
            _background.layer.borderColor = self.onColor.CGColor;
            _onImageView.alpha = 1.0;
            _offImageView.alpha = 0;
        } completion:^(BOOL finished) {
            _isAnimating = NO;
        }];
    }
    else {
        if (self.tracking)
            _knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), _knob.frame.origin.y, activeKnobWidth, _knob.frame.size.height);
        else
            _knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), _knob.frame.origin.y, normalKnobWidth, _knob.frame.size.height);
        _background.backgroundColor = self.onColor;
        _background.layer.borderColor = self.onColor.CGColor;
        _onImageView.alpha = 1.0;
        _offImageView.alpha = 0;
    }

}
- (void)showOff:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        _isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking) {
                _knob.frame = CGRectMake(1, _knob.frame.origin.y, activeKnobWidth, _knob.frame.size.height);
                _background.backgroundColor = self.activeColor;
            }
            else {
                _knob.frame = CGRectMake(1, _knob.frame.origin.y, normalKnobWidth, _knob.frame.size.height);
                _background.backgroundColor = self.inactiveColor;
            }
            _background.layer.borderColor = self.borderColor.CGColor;
            _onImageView.alpha = 0;
            _offImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            _isAnimating = NO;
        }];
    }
    else {
        if (self.tracking) {
            _knob.frame = CGRectMake(1, _knob.frame.origin.y, activeKnobWidth, _knob.frame.size.height);
            _background.backgroundColor = self.activeColor;
        }
        else {
            _knob.frame = CGRectMake(1, _knob.frame.origin.y, normalKnobWidth, _knob.frame.size.height);
            _background.backgroundColor = self.inactiveColor;
        }
        _background.layer.borderColor = self.borderColor.CGColor;
        _onImageView.alpha = 0;
        _offImageView.alpha = 1.0;
    }
}











@end
