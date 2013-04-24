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
        
        _saveFileName = @"New Save File";
        _saveIdentifier = [NSUUID UUID];
        
        _mainQuestStageIdentifier = @(0);
        _sideQuestIdentifers = [NSMutableArray new];
        
        _currentMapName = nil;
        _mapStates = [NSMutableDictionary new];
        
        _playerState = [MBPlayableCharacterState new];
        _score  = [NSDecimalNumber decimalNumberWithString:@"0.0"];
        
    }
    return self;
}

#pragma mark - Deserialization

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    [dictionary setObject:[self saveFileName] forKey:@"saveFileName"];
    [dictionary setObject:[[self saveIdentifier] UUIDString] forKey:@"saveIdentifier"];
    [dictionary setObject:[self mainQuestStageIdentifier] forKey:@"mainQuestStageIdentifier"];
    [dictionary setObject:[self sideQuestIdentifers] forKey:@"sideQuestIdentifiers"];
    [dictionary setObject:[self currentMapName] forKey:[self currentMapName]];
    [dictionary setObject:[NSMutableArray new] forKey:@"mapStates"];

    for (MBMapState *mapState in [self mapStates]) {
        [dictionary[@"mapStates"] addObject:[mapState asDictionary]];
    }
    
    [dictionary setObject:[[self playerState] asDictionary] forKey:@"playerState"];
    [dictionary setObject:[[self score]stringValue] forKey:@"score"];
    
    return dictionary;
}

#pragma mark Serialization

//
//  This method returns a fully configured game
//  state from a given dictionary.
//

+ (MBGameState *)gameStateFromDictionary:(NSDictionary *)dictionary
{
    MBGameState *state = [MBGameState new];
    
    [state setSaveFileName:dictionary[@"fileName"]];
    [state setSaveIdentifier:[[NSUUID alloc] initWithUUIDString:dictionary[@"UUID"]]];
    [state setMainQuestStageIdentifier:dictionary[@"mainQuestStageIdentifier"]];
    [state setSideQuestIdentifers:[dictionary[@"sideQuestIdentifiers"] mutableCopy]];
    [state setCurrentMapName:dictionary[@"currentMapName"]];
    [state setMapStates:[NSMutableDictionary new]];
    
    for (NSDictionary *mapStateData in dictionary[@"mapStates"]) {
        MBMapState *mapState = [MBMapState mapStateWithDictionary:mapStateData];
        [[state mapStates] setObject:mapState forKey:mapStateData[@"mapName"]];
    }
    
    [state setPlayerState:[MBPlayableCharacterState playableCharacterStateWithDictionary:dictionary[@"playerState"]]];
    
    [state setScore:[NSDecimalNumber decimalNumberWithString:dictionary[@"score"]]];
    
    return state;
}

@end
