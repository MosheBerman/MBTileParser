//
//  MBSpriteView.m
//  TileParser
//
//  Created by Andrew Dudney on 8/16/12.
//
//

#import "MBSpriteView.h"

#import "MBControllerEvent.h"

#import "MBJoystickView.h"

@interface MBSpriteView()

@property (nonatomic, strong) NSDictionary *animations;
@property (nonatomic) BOOL isMoving;
@end

@implementation MBSpriteView

- (id)initWithAnimations:(NSDictionary *)animations{
	self = [super init];
	if(self){
		
        _animations = animations;
		self.animationDuration = 1.0/3.0;
        
        NSString *randomKey = [[animations allKeys] objectAtIndex:0];
        CGSize imageSize = [[[animations objectForKey:randomKey] objectAtIndex:0] size];
        
        self.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        self.contentMode = UIViewContentModeTopLeft;
        
        _isMoving = NO;
	}
	return self;
}

- (void)beginAnimation:(NSString *)animationID{
	self.animationImages = [self.animations objectForKey:animationID];
	[self startAnimating];
}

- (void)stopAnimation{
	[self stopAnimating];
	self.image = self.animationImages[0];
	self.animationImages = nil;
}


#pragma mark - Movement Methods

- (void) setDirection:(NSString *)direction{
	self.animationImages = [[self animations] objectForKey:direction];
	self.image = self.animationImages[0];
}

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
        [self stopAnimation];
        [self setIsMoving:NO];
        return;
    }
    
    [UIView animateWithDuration:distanceInTiles*0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self setFrame:oldFrame];
    }
                     completion:^(BOOL finished) {
                         //  Perform whatever the callback warrants
                         if(completion){
                             completion();
                         }
                     }];
}

#pragma mark - Single Tile Movement

- (void) moveUpWithCompletion:(void (^)()) completion{
    [self beginAnimation:@"up"];
    [self moveInDirection:MBSpriteMovementDirectionVertical distanceInTiles:-1 withCompletion:completion];
}

- (void) moveDownWithCompletion:(void (^)()) completion{
    [self beginAnimation:@"down"];
    [self moveInDirection:MBSpriteMovementDirectionVertical distanceInTiles:1 withCompletion:completion];
}

- (void) moveLeftWithCompletion:(void (^)()) completion{
    [self beginAnimation:@"left"];
    [self moveInDirection:MBSpriteMovementDirectionHorizontal distanceInTiles:-1 withCompletion:completion];
}

- (void) moveRightWithCompletion:(void (^)()) completion{
    [self beginAnimation:@"right"];
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
        
        [self setDirection:@"right"];
        [self setIsMoving:YES];
        [self startAnimating];
        
        [self moveRightWithCompletion:^{
            [self setIsMoving:NO];
            [self stopAnimation];
        }];
    }
    
    if(velocity.y == 1){

        [self setDirection:@"up"];        
        [self setIsMoving:YES];
        [self startAnimating];
        
        [self moveUpWithCompletion:^{
            [self setIsMoving:NO];
            [self stopAnimation];
        }];
    }
    
    if (velocity.x == -1) {

        [self setDirection:@"left"];        
        [self setIsMoving:YES];
        [self startAnimating];
        
        [self moveLeftWithCompletion:^{
            [self setIsMoving:NO];
            [self stopAnimation];
        }];
    }
    
    if(velocity.y == -1){

        [self setDirection:@"down"];        
        [self setIsMoving:YES];
        [self startAnimating];
        
        [self moveDownWithCompletion:^{
            [self setIsMoving:NO];
            [self stopAnimation];
        }];
    }
    
}

@end
