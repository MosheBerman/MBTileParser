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
@property (nonatomic, assign) BOOL isMoving;

@property (readonly, nonatomic, strong) NSDictionary *animations;

//  Initializer
- (id) initWithSpriteName:(NSString *)name;

//  Animation playback control methods
- (void)beginAnimationWithKey:(NSString *)animationID;
- (void)stopAnimation;

// Set the image to the first frame of a given animation
- (void) setActiveAnimation:(NSString *)direction;

//
//  Move N tiles in a given direction.
//  The size of a tile is determined by the movementDelegate.
//

- (void) moveInDirection:(MBSpriteMovementDirection)direction distanceInTiles:(NSInteger)distanceInTiles withCompletion:(void (^)())completion;

//
//  Move one 'tile' in a given direction.
//  The size of a tile is determined by the movementDelegate.
//

- (void) moveUpWithCompletion:(void (^)())completion;
- (void) moveDownWithCompletion:(void (^)())completion;
- (void) moveLeftWithCompletion:(void (^)())completion;
- (void) moveRightWithCompletion:(void (^)())completion;

@end
