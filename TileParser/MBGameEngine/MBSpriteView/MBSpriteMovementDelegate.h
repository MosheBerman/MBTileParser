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
    MBSpriteMovementDirectionVertical,
    MBSpriteMovementDirectionHorizontal
};

@class MBSpriteView;

@protocol MBSpriteMovementDelegate <NSObject>

- (BOOL)sprite:(MBSpriteView *)sprite canMoveToCoordinates:(CGPoint)coordinates;
- (float)sprite:(MBSpriteView *)sprite distanceToMoveInDirection:(MBSpriteMovementDirection)direction;  //In points
- (void)sprite:(MBSpriteView *)sprite interactWithTileAtCoordinates:(CGPoint)coordinates;
- (CGSize)tileSizeInPointsForSprite:(MBSpriteView *)sprite;

@end

@protocol MBSpriteMovementDelegateDelegate <MBSpriteMovementDelegate>

@end
