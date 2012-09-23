//
//  MBJoystickViewController.h
//  TileParser
//
//  Created by Moshe Berman on 8/27/12.
//
//

#import "MBControllerViewController.h"

@interface MBJoystickView : UIView

@property (nonatomic, readonly) float degrees;
@property (nonatomic, readonly) CGPoint velocity;
@property (nonatomic, readonly) CGPoint stickPosition;

@property (nonatomic) BOOL autoCenter;
@property (nonatomic) BOOL isDPad;
@property (nonatomic) BOOL hasDeadZone;
@property (nonatomic) NSInteger numberOfDirections;

@property (nonatomic) float joystickRadius;
@property (nonatomic) float thumbRadius;
@property (nonatomic) float deadRadius;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *thumbView;

@property (nonatomic) float repeatInterval;
@property (nonatomic) BOOL shouldRepeat;


- (id)initWithFrame:(CGRect)frame;

- (void)setBackgroundImage:(UIImage *)image;
- (void)setThumbImage:(UIImage *)image;

@end
