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

        [self setContentMode:UIViewContentModeCenter];
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
- (void)moveInDirection:(MBSpriteMovementDirection)direction distanceInTiles:(NSInteger)distanceInTiles withCompletion:(MBMovementCompletionHandler)completion{
    
    CGRect oldFrame = [self frame];
    CGSize tileDimensions = CGSizeZero;
    
    tileDimensions = [[self movementDataSource] tileSizeInPoints];
    
    if (tileDimensions.height == 0 && tileDimensions.width == 0) {
        
        NSLog(@"The tile dimensions for the movement method are zero. Did you forget to set a data source?\nI can't do anything with this steaming pile of variables. I'm outta here!");
        
        return;
    }
    
    CGPoint tileCoordinates = CGPointMake(oldFrame.origin.x/tileDimensions.width, oldFrame.origin.y/tileDimensions.height);
    
    //  Calculate the new position
    if (direction == MBSpriteMovementDirectionLeft || direction == MBSpriteMovementDirectionRight) {
        oldFrame.origin.x += (tileDimensions.width * distanceInTiles);
        tileCoordinates.x += distanceInTiles;
    }else{
        oldFrame.origin.y += (tileDimensions.height * distanceInTiles);
        tileCoordinates.y += distanceInTiles;
    }
    
    if (![[self movementDelegate] sprite:self canMoveToCoordinates:tileCoordinates]) {
        [self resetMovementState];
        if(completion){
            completion();
        }
        return;
    }
    
    [self startMoving];
    
    CGFloat duration = abs(distanceInTiles)*[self movementTimeScaleFactor];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
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

- (void)startMoving{
    [self setIsMoving:YES];
    [self startAnimating];
}

- (void)resetMovementState{
    [self setIsMoving:NO];
    [self stopAnimation];
}

#pragma mark - Single Tile Movement Convenience Methods

- (void)moveUpWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"up"];
    [self moveInDirection:MBSpriteMovementDirectionUp distanceInTiles:-1 withCompletion:completion];
}

- (void)moveDownWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"down"];
    [self moveInDirection:MBSpriteMovementDirectionDown distanceInTiles:1 withCompletion:completion];
}

- (void)moveLeftWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"left"];
    [self moveInDirection:MBSpriteMovementDirectionLeft distanceInTiles:-1 withCompletion:completion];
}

- (void)moveRightWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"right"];
    [self moveInDirection:MBSpriteMovementDirectionRight distanceInTiles:1 withCompletion:completion];
}

#pragma mark - Rotation Only Convenience Methods

- (void)faceUpWithCompletion:(void (^)()) completion {
    [self beginAnimationWithKey:@"up"];
    [self resetMovementState];
    if(completion){
        completion();
    }
}

- (void)faceDownWithCompletion:(void (^)()) completion {
    [self beginAnimationWithKey:@"down"];
    [self resetMovementState];
    if(completion){
        completion();
    }
}

- (void)faceLeftWithCompletion:(void (^)()) completion {
    [self beginAnimationWithKey:@"left"];
    [self resetMovementState];
    if(completion){
        completion();
    }
}

- (void)faceRightWithCompletion:(void (^)()) completion {
    [self beginAnimationWithKey:@"right"];
    [self resetMovementState];
    if(completion){
        completion();
    }
}

#pragma mark - Game Controller Support

- (void)gameController:(MBControllerViewController *)controller buttonPressedWithSender:(id)sender{
    
}

- (void)gameController:(MBControllerViewController *)controller buttonReleasedWithSender:(id)sender{
    
}

- (void)gameController:(MBControllerViewController *)controller joystickValueChangedWithSender:(id)value{
    
    //
    //  If we're mid-move, don't do anything.
    //
    
    if (_isMoving) {
        return;
    }
    
    //
    //  Setup...
    //
    
    MBJoystickView *joystick = value;
    
    CGPoint velocity = [joystick velocity];
    
    MBSpriteMovementDirection direction = [self directionFromVelocity:velocity];
    
    MBMovementCompletionHandler handler = ^(){
        [[self movementDelegate] sprite:self interactWithTileAtCoordinates:[self frame].origin];
    };
    
    //
    //  Check for ability to turn
    //
    
    BOOL canTurn = [[self movementDelegate] sprite:self canTurnToFaceDirection:direction];
    
    if (!canTurn) {
        return;
    }

    //
    //  Set the direction
    //
    
    [self setDirection:direction];
    
    //
    //  Move
    //
    
    if (velocity.x == 1) {
        [self moveRightWithCompletion:handler];
    }
    
    if(velocity.y == 1){
        [self moveUpWithCompletion:handler];
    }
    
    if (velocity.x == -1) {
        [self moveLeftWithCompletion:handler];
    }
    
    if(velocity.y == -1){
        [self moveDownWithCompletion:handler];
    }
}

- (void) setDirection:(MBSpriteMovementDirection)direction{
    
    _direction = direction;
    
    [self setActiveAnimation:[self animationKeyForDirection:direction]];
}

//
//  This method converts an MBSpriteMovementDirection into a
//  related string. These strings are used as animation keys.
//

- (NSString *) animationKeyForDirection:(MBSpriteMovementDirection)direction{
 
    NSArray *directionStrings = @[@"up", @"right", @"down", @"left"];
    
    return directionStrings[direction];
    
}

//
//  Converts a velocity into a direction enum value.
//

- (MBSpriteMovementDirection) directionFromVelocity:(CGPoint)velocity{
    
    if (velocity.x == 1) {
        return MBSpriteMovementDirectionRight;
    }
    else if (velocity.y == 1) {
        return MBSpriteMovementDirectionUp;
    }
    else if(velocity.x == -1){
        return MBSpriteMovementDirectionLeft;
    }
    else{
        return MBSpriteMovementDirectionDown;
    }
}

//
//  A readonly version of the animationKeyForDirection:
//  method that's publically exposed.
//

- (NSString *)directionKey{
    return [self animationKeyForDirection:[self direction]];
}

@end
