//
//  MBGameState.m
//  TileParser
//
//  Created by Moshe Berman on 2/21/13.
//
//

#import "MBGameState.h"

@implementation MBGameState

- (id)init
{
    self = [super init];
    if (self) {
        
        //
        //  Initialize the empty arrays and default values
        //
        
        _spriteStates = [@[] mutableCopy];
        _itemStates = [@[] mutableCopy];
        _mapName = nil;
    }
    return self;
}

@end
