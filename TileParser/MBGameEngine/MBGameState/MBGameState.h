//
//  MBGameState.h
//  TileParser
//
//  Created by Moshe Berman on 2/21/13.
//
//

#import <Foundation/Foundation.h>

#import "MBCharacterState.h"

#import "MBItemState.h"

#import "MBPlayableCharacterState.h"


@interface MBGameState : NSObject

@property (nonatomic, strong) NSString *saveFileName;           //  The name of the save file
@property (nonatomic, strong) NSNumber *saveIdentifier;         //  The unique ID of the save file

@property (nonatomic, strong) NSNumber *mainQuestIdentifier;    // A master "level" for the game.
@property (nonatomic, strong) NSArray *sideQuestIdentifers;     // An array of arbitrary identifiers for side quests.

@property (nonatomic, strong) NSString *currentMapName;     // Name of the currently playing map.
@property (nonatomic, strong) NSDictionary *mapStates;      // Map states for all available maps.

@property (nonatomic, strong) MBPlayableCharacterState *playerState;  //  Player name, stamina, superpowers, etc.

@end
