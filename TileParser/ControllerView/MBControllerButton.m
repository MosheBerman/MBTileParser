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

@implementation MBControllerButton

- (id)initWithRadius:(CGFloat)radius
{
    
    CGRect frame = CGRectMake(0, 0, radius*2, radius*2);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _color = [UIColor whiteColor];
        _radius = radius;
    }
    return self;
}

- (id) initWithColor:(UIColor *) color{
    
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
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [[self layer] setBorderColor:[self color].CGColor];
    [[self layer] setBorderWidth:1.0f];
    [[self layer] setBackgroundColor:[[self color] colorByChangingAlphaTo:0.7].CGColor];
    [[self layer] setCornerRadius:[self radius]];
}


@end
