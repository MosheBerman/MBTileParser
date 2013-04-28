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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    
    if (self) {
        _saveFileName = [aDecoder decodeObjectForKey:@"saveFileName"];
        _saveIdentifier = [aDecoder decodeObjectForKey:@"saveIdentifier"];
        _mainQuestStageIdentifier = [aDecoder decodeObjectForKey:@"mainQuestStageIdentifier"];
        _sideQuestIdentifers = [aDecoder decodeObjectForKey:@"sideQuestIdentifiers"];
        _currentMapName = [aDecoder decodeObjectForKey:@"currentMapName"];
        _playerState = [aDecoder decodeObjectForKey:@"playerState"];
        _score = [aDecoder decodeObjectForKey:@"score"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self saveFileName] forKey:@"saveFileName"];
    
    [aCoder encodeObject:[[self saveIdentifier] UUIDString] forKey:@"saveIdentifier"];
    [aCoder encodeObject:[self mainQuestStageIdentifier] forKey:@"mainQuestStageIdentifier"];
    [aCoder encodeObject:[self sideQuestIdentifers] forKey:@"sideQuestIdentifiers"];
    [aCoder encodeObject:[self currentMapName] forKey:[self currentMapName]];
    [aCoder encodeObject:[self mapStates] forKey:@"mapStates"];
    [aCoder encodeObject:[self playerState] forKey:@"playerState"];
    [aCoder encodeObject:[[self score]stringValue] forKey:@"score"];
}

@end
