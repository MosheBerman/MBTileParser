//
//  MBMovableSpriteView.m
//  TileParser
//
//  Created by Moshe Berman on 9/7/12.
//
//

#import "MBMovableSpriteView.h"

#import "MBControllerEvent.h"

#import "MBJoystickView.h"

@implementation MBMovableSpriteView

- (id)initWithSpriteName:(NSString *)name{
    self = [super initWithSpriteName:name];
    
    if (self) {
        
        _movementTimeScaleFactor = kDefaultMovementDuration;
        self.animationDuration = 1.0 * _movementTimeScaleFactor;
        _isMoving = NO;
    }
    
    return self;
}

#pragma mark - Custom Setters

- (void)setMovementTimeScaleFactor:(float)movementTimeScaleFactor{
    _movementTimeScaleFactor = movementTimeScaleFactor;
    self.animationDuration = 1.0 * movementTimeScaleFactor;
}

#pragma mark - Movement Methods

//  Move in a direction
- (void) moveInDirection:(MBSpriteMovementDirection)direction distanceInTiles:(NSInteger)distanceInTiles withCompletion:(void (^)())completion{
    
    CGRect oldFrame = [self frame];
    CGSize tileDimensions = [[self movementDelegate] tileSizeInPoints];
    
    CGPoint tileCoordinates = CGPointMake(oldFrame.origin.x/tileDimensions.width, oldFrame.origin.y/tileDimensions.height);
    
    //  Calculate the new position
    if (direction == MBSpriteMovementDirectionHorizontal) {
        oldFrame.origin.x += (tileDimensions.width * distanceInTiles);
        tileCoordinates.x += distanceInTiles;
    }else{
        oldFrame.origin.y += (tileDimensions.height * distanceInTiles);
        tileCoordinates.y += distanceInTiles;
    }
    
    if (![[self movementDelegate] tileIsOpenAtCoordinates:tileCoordinates forSprite:self]) {
        [self resetMovementState];
        return;
    }
    
    [self startMoving];
    
    [UIView animateWithDuration:distanceInTiles*[self movementTimeScaleFactor] delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        [self setFrame:oldFrame];
    }
                     completion:^(BOOL finished) {
                         //  Perform whatever the callback warrants
                         if(completion){
                             completion();
                         }
                         [self resetMovementState];
                     }];
}

- (void) startMoving{
    [self setIsMoving:YES];
    [self startAnimating];
}

- (void) resetMovementState{
    [self setIsMoving:NO];
    [self stopAnimation];
}

#pragma mark - Single Tile Movement Convenience Methods

- (void) moveUpWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"up"];
    [self moveInDirection:MBSpriteMovementDirectionVertical distanceInTiles:-1 withCompletion:completion];
}

- (void) moveDownWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"down"];
    [self moveInDirection:MBSpriteMovementDirectionVertical distanceInTiles:1 withCompletion:completion];
}

- (void) moveLeftWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"left"];
    [self moveInDirection:MBSpriteMovementDirectionHorizontal distanceInTiles:-1 withCompletion:completion];
}

- (void) moveRightWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"right"];
    [self moveInDirection:MBSpriteMovementDirectionHorizontal distanceInTiles:1 withCompletion:completion];
}

#pragma mark - Game Controller Support

- (void)gameController:(MBControllerViewController *)controller buttonsPressedWithSender:(id)sender{
    
}

- (void)gameController:(MBControllerViewController *)controller buttonsReleasedWithSender:(id)sender{
    
}

- (void)gameController:(MBControllerViewController *)controller joystickValueChangedWithSender:(id)value{
    
    if (_isMoving) {
        return;
    }
    
    MBJoystickView *joystick = value;
    
    CGPoint velocity = [joystick velocity];
    
    if (velocity.x == 1) {
        
        [self setActiveAnimation:@"right"];
        [self moveRightWithCompletion:nil];
    }
    
    if(velocity.y == 1){
        
        [self setActiveAnimation:@"up"];
        [self moveUpWithCompletion:nil];
    }
    
    if (velocity.x == -1) {
        
        [self setActiveAnimation:@"left"];
        [self moveLeftWithCompletion:nil];
    }
    
    if(velocity.y == -1){
        
        [self setActiveAnimation:@"down"];
        [self moveDownWithCompletion:nil];
    }
}

@end
