//
//  MBMovableSpriteView.h
//  TileParser
//
//  Created by Moshe Berman on 9/7/12.
//
//

#import "MBSpriteView.h"

#import "MBSpriteMovementDelegate.h"

#define kMovementDuration 0.45

@interface MBMovableSpriteView : MBSpriteView

@property (nonatomic, assign) id<MBSpriteMovementDelegate> movementDelegate;
@property (nonatomic, assign) BOOL isMoving;

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
