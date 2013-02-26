//
//  MBGameState.h
//  TileParser
//
//  Created by Moshe Berman on 2/21/13.
//
//

#import <Foundation/Foundation.h>

#import "MBSpriteState.h"

#import "MBItemState.h"

@interface MBGameState : NSObject

@property (nonatomic, strong) NSString *mapName;        // Name of the currently playing map
@property (nonatomic, strong) NSArray *spriteStates;    // An array of MBSpriteState objects
@property (nonatomic, strong) NSArray *itemStates;      // An array of MBItemState objects

@end
