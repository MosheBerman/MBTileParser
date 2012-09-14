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

- (CGSize)tileSizeInPoints;
- (BOOL)sprite:(MBSpriteView *)sprite canMoveToCoordinates:(CGPoint)coordinates;
- (void)sprite:(MBSpriteView*)sprite interactWithTileAtCoordinates:(CGPoint)coordinates;

@end
