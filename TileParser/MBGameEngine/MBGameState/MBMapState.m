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

#pragma mark - Deserialization

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:[self mapName] forKey:@"mapName"];
    [dictionary setObject:[NSMutableArray new] forKey:@"characterStates"];
    [dictionary setObject:[NSMutableArray new] forKey:@"itemStates"];
    
    for (MBCharacterState *state in [self characterStates]) {
        [dictionary[@"characterStates"] addObject:[state asDictionary]];
    }
    
    for (MBItemState *state in [self itemStates]) {
        [dictionary[@"itemStates"] addObject:[state asDictionary]];
    }
    
    return dictionary;
}

#pragma mark - Serialization

+ (MBMapState *)mapStateWithDictionary:(NSDictionary *)dictionary
{
    MBMapState *state = [MBMapState new];
    
    [state setMapName:dictionary[@"mapName"]];
    [state setDisplayName:dictionary[@"displayName"]];
    [state setCharacterStates:[NSMutableArray new]];
    [state setItemStates:[NSMutableArray new]];
    
    for (NSDictionary *characterStateData in dictionary[@"characterStates"]) {
        MBPlayableCharacterState *characterState = [MBPlayableCharacterState playableCharacterStateWithDictionary:characterStateData];
        [[state characterStates] addObject:characterState];
    }
    
    for (NSDictionary *itemStateData in dictionary[@"itemStates"]) {
        MBItemState *itemState = [MBItemState itemStateWithDictionary:itemStateData];
        [[state itemStates] addObject:itemState];
    }
    
    return state;
}

@end
