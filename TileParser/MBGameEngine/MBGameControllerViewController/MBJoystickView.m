//
//  MBJoystickViewController.m
//  TileParser
//
//  Created by Moshe Berman on 8/27/12.
//
//

#import "MBJoystickView.h"

#import <QuartzCore/QuartzCore.h>

#import "UIColor+Extensions.h"

#define kJoystickPI 3.1415926539f

#define kJoystickPIx2 6.2831850718f

#define kJoystickRadiansToDegrees 180.0f/kJoystickPI

#define kJoystickDegreesToRadians kJoystickPI/180.0f

#define CGPointCenter CGPointMake(_joystickRadius, _joystickRadius)

@interface MBJoystickView ()

- (void) updateVelocity:(CGPoint)point;

@property (nonatomic) float joystickRadiusSquared;
@property (nonatomic) float thumbRadiusSquared;
@property (nonatomic) float deadRadiusSquared;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic, strong) NSTimer *repeatTimer;

@end

@implementation MBJoystickView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        _velocity  = CGPointZero;
        _degrees = 0;
        _autoCenter = YES;
        _isDPad = NO;
        _hasDeadZone = NO;
        _numberOfDirections = 4;
        
        _joystickRadius = frame.size.width/2;
        _thumbRadius = 32.0f;
        _deadRadius = 0.0f;
        
        _stickPosition = CGPointCenter;
        
        _repeatInterval = 0.01;
        _repeatTimer = nil;
        _lastPoint = _stickPosition;
        _shouldRepeat = YES;
        
        [self setMultipleTouchEnabled:NO];
        
        self.layer.cornerRadius = _joystickRadius;
        [self setColor:[UIColor lightGrayColor]];
    }
    
    return self;
}


- (void)repeatVelocity{
    [self updateVelocity:[self lastPoint]];
}

- (void)updateVelocity:(CGPoint)point{
    
    [self setLastPoint:point];
    
    if (point.x == 0 && point.y == 0) {
        [[self thumbView] setCenter:[[self backgroundView] center]];
    }else{
        
        CGPoint thumbCenter = point;
        
        thumbCenter.x = MIN(MAX(0, thumbCenter.x), self.bounds.size.width);
        thumbCenter.y = MIN(MAX(0, thumbCenter.y), self.bounds.size.height);
        
        [[self thumbView] setCenter:thumbCenter];
    }
    
    point.x = point.x - _joystickRadius;
    point.y = _joystickRadius - point.y;
    
    
    
    float dx = point.x;
    float dy = point.y;
    
    float distanceSquared = dx * dx + dy * dy;
    
    
    if(distanceSquared <= _deadRadiusSquared){
        
        [self willChangeValueForKey:@"velocity"];
        _velocity = CGPointZero;
        [self didChangeValueForKey:@"velocity"];
        
        _degrees = 0.0f;
        
        [self willChangeValueForKey:@"stickPosition"];
        _stickPosition = CGPointCenter;
        [self didChangeValueForKey:@"stickPosition"];
        
        return;
    }
    
    //TODO: See if this angle is incorrect.
    float angle = atan2f(dy, dx);   //In radians
    
    if(angle < 0){
        angle += kJoystickPIx2;
    }
    
    float cosAngle;
    float sinAngle;
    
    if(_isDPad){
        float anglePerSector = 360.0f / _numberOfDirections * kJoystickDegreesToRadians;
        angle = roundf(angle/anglePerSector) * anglePerSector;
    }
    
    cosAngle = cosf(angle);
    sinAngle = sinf(angle);
    
    //NOTE: Velocity goes from -1.0 to 1.0
    if(distanceSquared > _joystickRadiusSquared || _isDPad){
        dx = cosAngle * _joystickRadius;
        dy = sinAngle * _joystickRadius;
    }
    
    [self willChangeValueForKey:@"velocity"];
    _velocity = CGPointMake(dx/_joystickRadius, dy/_joystickRadius);
    [self didChangeValueForKey:@"velocity"];
    
    _degrees = angle * kJoystickRadiansToDegrees;
    
    [self willChangeValueForKey:@"stickPosition"];
    _stickPosition = CGPointMake(dx, dy);
    [self didChangeValueForKey:@"stickPosition"];
    
    
}

- (void) setIsDPad:(BOOL)isDPad{
    _isDPad = isDPad;
    if (isDPad) {
        _hasDeadZone = YES;
        self.deadRadius = 10.0f;
    }
}

- (void)setJoystickRadius:(float)joystickRadius{
    _joystickRadius = joystickRadius;
    _joystickRadiusSquared = joystickRadius * joystickRadius;
}

- (void)setThumbRadius:(float)thumbRadius{
    _thumbRadius = thumbRadius;
    _thumbRadiusSquared = thumbRadius * thumbRadius;
}

- (void)setDeadRadius:(float)deadRadius{
    _deadRadius = deadRadius;
    _deadRadiusSquared = deadRadius * deadRadius;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    
    //  This check may be entirely unnecessary and it breaks d-pad mode, so
    //  we won't use it.
    
    //
    //    BOOL joystickContainsTouch = CGRectContainsPoint(self.frame, location);
    //
    //   if (joystickContainsTouch) {
    float dSq = location.x * location.x + location.y * location.y;
    
    if (_joystickRadiusSquared > dSq || [self isDPad]) {
        [self updateVelocity:location];
    }
    //    }
    
    //  Set up a repeat dispatch while
    
    if ([self shouldRepeat] && (![self repeatTimer] || ![[self repeatTimer] isValid])) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:[self repeatInterval] target:self selector:@selector(repeatVelocity) userInfo:nil repeats:YES];
        [self setRepeatTimer:timer];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint location = [[touches anyObject] locationInView:self];
    [self updateVelocity:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    if (_autoCenter) {
        location = CGPointMake([self joystickRadius], [self joystickRadius]);
    }
    
    [self updateVelocity:location];
    
    if ([self repeatTimer]) {
        [[self repeatTimer] invalidate];
        self.repeatTimer = nil;
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
    
    if ([self repeatTimer]) {
        [[self repeatTimer] invalidate];
        self.repeatTimer = nil;
    }
}

#pragma mark - Set Color

- (void)setColor:(UIColor*)color{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.backgroundColor = [color colorByChangingAlphaTo:0.65].CGColor;
}

- (void)setBackgroundView:(UIView *)backgroundView{
    _backgroundView = backgroundView;
    
    if(backgroundView){
        [self setBackgroundColor:[UIColor clearColor]];
        [[self layer] setBorderWidth:0];
        [[self layer] setCornerRadius:0];
    }else{
        self.layer.cornerRadius = [self joystickRadius];
        [self setColor:[UIColor lightGrayColor]];
    }
}

- (void)setBackgroundImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[self bounds]];
    [imageView setImage:image];
    [self setBackgroundView:imageView];
    
    if ([self backgroundView]) {
        [self addSubview:[self backgroundView]];
    }
}

- (void)setThumbImage:(UIImage *)image{
    
    CGRect frame = CGRectMake(0, 0, [self thumbRadius], [self thumbRadius]);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setCenter:[[self backgroundView] center]];
    [imageView setImage:image];
    [self setThumbView:imageView];
    
    if ([self thumbView]) {
        [self addSubview:[self thumbView]];
        [self bringSubviewToFront:[self thumbView]];
    }
}

@end
