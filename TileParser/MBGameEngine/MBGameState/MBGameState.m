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

@end
