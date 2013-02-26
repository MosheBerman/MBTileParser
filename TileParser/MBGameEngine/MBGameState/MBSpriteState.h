//
//  MBSpriteState.h
//  TileParser
//
//  Created by Moshe Berman on 2/21/13.
//
//

#import <Foundation/Foundation.h>

#import "MBSpriteMovementDelegate.h"    // Import for direction enum

@interface MBSpriteState : NSObject

@property (nonatomic, assign) MBSpriteMovementDirection direction;  // What direction is the sprite facing
@property (nonatomic, assign) CGFloat originInTiles;                // Where is the sprite located?
@property (nonatomic, strong) NSString *name;                       //What is the sprite name?

@end
