//
//  MBMovableSpriteView.h
//  TileParser
//
//  Created by Moshe Berman on 9/7/12.
//
//

#import "MBSpriteView.h"

#import "MBSpriteMovementDelegate.h"

#import "MBMapMetadata.h"

#define kDefaultMovementDuration 0.4

typedef void(^MBMovementCompletionHandler)();

@interface MBMovableSpriteView : MBSpriteView

@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) id<MBSpriteMovementDelegate> movementDelegate;
@property (nonatomic, assign) id<MBMapMetadata> movementDataSource;
@property (nonatomic, assign) float movementTimeScaleFactor;    // Used to calculate how long animations and movements take
@property (nonatomic, assign) MBSpriteMovementDirection direction;
@property (nonatomic, readonly) NSString *directionKey;

//
//  Move N tiles in a given direction.
//  The size of a tile is determined by the movementDelegate.
//

- (void)moveInDirection:(MBSpriteMovementDirection)direction distanceInTiles:(NSInteger)distanceInTiles withCompletion:(void (^)())completion;

//
//  Move one 'tile' in a given direction.
//  The size of a tile is determined by the movementDelegate.
//

- (void)moveUpWithCompletion:(MBMovementCompletionHandler)completion;
- (void)moveDownWithCompletion:(MBMovementCompletionHandler)completion;
- (void)moveLeftWithCompletion:(MBMovementCompletionHandler)completion;
- (void)moveRightWithCompletion:(MBMovementCompletionHandler)completion;

- (void)faceUpWithCompletion:(void (^)()) completion;
- (void)faceDownWithCompletion:(void (^)()) completion;
- (void)faceLeftWithCompletion:(void (^)()) completion;
- (void)faceRightWithCompletion:(void (^)()) completion;

@end
