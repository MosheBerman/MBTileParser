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
- (BOOL) spriteCanTurn:(MBSpriteView *)sprite toFaceDirection:(MBSpriteMovementDirection)direction;

- (void) sprite:(MBSpriteView *)sprite interactWithTileAtCoordinates:(CGPoint)coordinates;

@end
