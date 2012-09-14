//
//  MBControllerButton.m
//  TileParser
//
//  Created by Moshe Berman on 9/3/12.
//
//

#import "MBControllerButton.h"

#import <QuartzCore/QuartzCore.h>

#import "UIColor+Extensions.h"

@interface MBControllerButton ()
@property (nonatomic, assign) BOOL isPressed;
@end

@implementation MBControllerButton

- (id)initWithRadius:(CGFloat)radius{
    
    CGRect frame = CGRectMake(0, 0, radius*2, radius*2);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _color = [UIColor whiteColor];
        _radius = radius;
        _isPressed = NO;
        _indicatesTouch = YES;
    }
    return self;
}

- (id)initWithColor:(UIColor *) color{
    
    self = [self initWithRadius:32.0f];
    if (self) {
        // Initialization code
        _color = color;
    }
    return self;

}

+ (MBControllerButton *) buttonWithRadius:(CGFloat) radius{
    return [[MBControllerButton alloc] initWithRadius:radius];
}

+ (MBControllerButton *) buttonWithColor:(UIColor *) color{
    return [[MBControllerButton alloc] initWithColor:color];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    // Drawing code
    
    UIColor *borderColor = [self color];
    UIColor *fillColor = [borderColor colorByChangingAlphaTo:0.7];
    
    if([self isPressed] && [self indicatesTouch]){
        borderColor = [borderColor colorByChangingAlphaTo:0.7];
        fillColor = [borderColor colorByChangingAlphaTo:0.4];
    }
    
    [[self layer] setBorderColor:borderColor.CGColor];
    [[self layer] setBorderWidth:1.0f];
    [[self layer] setBackgroundColor:fillColor.CGColor];
    [[self layer] setCornerRadius:[self radius]];
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setIsPressed:YES];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setIsPressed:NO];
    [self setNeedsDisplay];
}

//
//  Set the button color then call setNeedsDisplay
//

- (void)setColor:(UIColor *)color{
    _color = color;
    [self setNeedsDisplay];
}

//
//  Resize the button, and keep it centered on its current position.
//

- (void)setRadius:(CGFloat)radius{
    CGPoint oldCenter = [self center];
    CGRect bounds = CGRectMake(0, 0, radius*2, radius*2);
    
    _radius = radius;
    
    [self setBounds:bounds];
    [self setNeedsDisplay];
    [self setCenter:oldCenter];
}

@end
