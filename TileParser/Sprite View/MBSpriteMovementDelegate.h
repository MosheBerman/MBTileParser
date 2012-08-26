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

@protocol MBSpriteMovementDelegate <NSObject>

- (CGSize) tileSizeInPoints;
- (BOOL) tileIsOpenAtCoordinates:(CGPoint)coordinates;

@end
