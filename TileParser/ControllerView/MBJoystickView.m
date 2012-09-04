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

@interface MBJoystickView ()
- (void) updateVelocity:(CGPoint)point;

@property (nonatomic) float joystickRadiusSquared;
@property (nonatomic) float thumbRadiusSquared;
@property (nonatomic) float deadRadiusSquared;

@end

@implementation MBJoystickView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        _stickPosition = CGPointZero;
        _degrees = 0;
        _velocity  = CGPointZero;
        _autoCenter = YES;
        _isDPad = NO;
        _hasDeadZone = NO;
        _numberOfDirections = 4;
        
        _joystickRadius = frame.size.width/2;
        _thumbRadius = 32.0f;
        _deadRadius = 0.0f;
        
        [self setMultipleTouchEnabled:NO];
        
        self.layer.cornerRadius = _joystickRadius;
        [self setColor:[UIColor lightGrayColor]];
    }
    
    return self;
}

- (void)updateVelocity:(CGPoint)point{
    
    point.x = point.x - _joystickRadius;
    point.y = _joystickRadius - point.y;
    
    
    
    float dx = point.x;
    float dy = point.y;
    
    float distanceSquared = dx * dx + dy * dy;
    
    if(distanceSquared <= _deadRadiusSquared){
        _velocity = CGPointZero;
        _degrees = 0.0f;
        _stickPosition = point;
        
        
        
        return;
    }

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

    _velocity = CGPointMake(dx/_joystickRadius, dy/_joystickRadius);
    _degrees = angle * kJoystickRadiansToDegrees;

    _stickPosition = CGPointMake(dx, dy);

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
    
    if (CGRectContainsPoint(self.frame, location)) {
        float dSq = location.x * location.x + location.y * location.y;
        
        if (_joystickRadiusSquared > dSq) {
            [self updateVelocity:location];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint location = [[touches anyObject] locationInView:self];
    [self updateVelocity:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    if (_autoCenter) {
        location = CGPointZero;
    }
    
    [self updateVelocity:location];
    
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}

- (void) setColor:(UIColor*)color{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.backgroundColor = [color colorByChangingAlphaTo:0.65].CGColor;
}

@end
