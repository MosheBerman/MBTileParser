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

- (id)initWithRadius:(CGFloat) radius;
- (id) initWithColor:(UIColor *) color;

+ (MBControllerButton *) buttonWithRadius:(CGFloat) radius;
+ (MBControllerButton *) buttonWithColor:(UIColor *) color;

@end
