//
//  MBSpriteMovementDelegate.h
//  TileParser
//
//  Created by Moshe Berman on 8/26/12.
//
//

#import <Foundation/Foundation.h>

typedef NSInteger MBSpriteMovementDirection;

enum MBSpriteMovementDirection {
    MBSpriteMovementDirectionUp = 0,
    MBSpriteMovementDirectionRight,
    MBSpriteMovementDirectionDown,
    MBSpriteMovementDirectionLeft
};

@class MBSpriteView;

@protocol MBSpriteMovementDelegate <NSObject>

- (BOOL) sprite:(MBSpriteView *)sprite canMoveToCoordinates:(CGPoint)coordinates;
- (void) sprite:(MBSpriteView *)sprite didMoveToCoordinates:(CGPoint)coordinates;
- (BOOL) sprite:(MBSpriteView *)sprite canTurnToFaceDirection:(MBSpriteMovementDirection)direction;

- (void) sprite:(MBSpriteView *)sprite interactWithTileAtCoordinates:(CGPoint)coordinates;

@end
