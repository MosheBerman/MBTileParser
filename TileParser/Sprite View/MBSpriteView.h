//
//  MBSpriteView.h
//  TileParser
//
//  Created by Andrew Dudney on 8/16/12.
//
//

#import <UIKit/UIKit.h>

#import "MBSpriteMovementDelegate.h"

@interface MBSpriteView : UIImageView

@property (nonatomic, assign) id<MBSpriteMovementDelegate> movementDelegate;

//  Designated initializer
- (id)initWithAnimations:(NSDictionary *)animations;

//  Begin a given animation
- (void)beginAnimation:(NSString *)animationID;

//  Stop whatever animation is playing
- (void)stopAnimation;

// Set the image to the first frame of a given animation
- (void) setDirection:(NSString *)direction;

//  Move in a direction
- (void) moveInDirection:(MBSpriteMovementDirection)direction distanceInTiles:(NSInteger)distanceInTiles withCompletion:(void (^)())completion;

- (void) moveUpWithCompletion:(void (^)()) completion;
- (void) moveDownWithCompletion:(void (^)()) completion;
- (void) moveLeftWithCompletion:(void (^)()) completion;
- (void) moveRightWithCompletion:(void (^)()) completion;
@end
