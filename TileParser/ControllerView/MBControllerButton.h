//
//  MBControllerButton.h
//  TileParser
//
//  Created by Moshe Berman on 9/3/12.
//
//

#import <UIKit/UIKit.h>

@interface MBControllerButton : UIButton

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) BOOL indicatesTouch;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic) float repeatInterval;
@property (nonatomic) BOOL shouldRepeat;

@property (nonatomic, assign) BOOL isPressed;

- (id)initWithRadius:(CGFloat)radius;
- (id)initWithColor:(UIColor *)color;

+ (MBControllerButton *)buttonWithRadius:(CGFloat)radius;
+ (MBControllerButton *)buttonWithColor:(UIColor *)color;

//
//  Set the button color then call setNeedsDisplay
//

- (void)setColor:(UIColor *)color;

//
//  Resize the button, and keep it centered on its current position.
//

- (void)setRadius:(CGFloat)radius;

@end
