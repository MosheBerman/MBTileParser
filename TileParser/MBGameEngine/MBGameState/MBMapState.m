//
//  MBMapState.m
//  TileParser
//
//  Created by Moshe Berman on 4/21/13.
//
//

#import "MBMapState.h"

#import "MBPlayableCharacterState.h"

#import "MBItemState.h"

@implementation MBMapState

- (id)init
{
    self = [super init];
    if (self) {
        _mapName = nil;
        _displayName = nil;
        _characterStates = [NSMutableArray new];
        _itemStates = [NSMutableArray new];
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _mapName = [aDecoder decodeObjectForKey:@"mapName"];
        _displayName = [aDecoder decodeObjectForKey:@"displayName"];
        _characterStates = [aDecoder decodeObjectForKey:@"characterStates"];
        _itemStates = [aDecoder decodeObjectForKey:@"itemStates"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self mapName] forKey:@"mapName"];
    [aCoder encodeObject:[self displayName] forKey:@"displayName"];
    [aCoder encodeObject:[self characterStates] forKey:@"characterStates"];
    [aCoder encodeObject:[self itemStates] forKey:@"itemStates"];
}

@end
