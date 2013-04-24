//
//  MBPlayerState.m
//  TileParser
//
//  Created by Moshe Berman on 4/21/13.
//
//

#import "MBPlayableCharacterState.h"

#import "MBItemState.h"


@implementation MBPlayableCharacterState

- (id)init
{
    self = [super init];
    if (self) {
        //  WATCH OUT for recursively nesting player in their own party. Might cause infinite recursion when (de)serializing...
        _party = [NSMutableArray new];
        _inventory = [NSMutableArray new];
        
        _maxStamina = [NSDecimalNumber decimalNumberWithString:@"0"];
        _stamina = _maxStamina;

        _level = @(0);
        _experience = @(0);
        _experienceForNextLevel = @(0);
    }
    
    return self;
}

+ (MBPlayableCharacterState *)playableCharacterStateWithDictionary:(NSDictionary *)dictionary
{
    
    MBPlayableCharacterState *state = (MBPlayableCharacterState *)[MBCharacterState characterStateWithDictionary:dictionary];
    
    // Party State
    for (NSDictionary *partyStateData in dictionary[@"party"]) {
        MBPlayableCharacterState *partyState = [MBPlayableCharacterState playableCharacterStateWithDictionary:partyStateData];
        [[state party] addObject:partyState];
    }
    
    //  Item State
    for (NSDictionary *itemStateData in dictionary[@"inventory"]) {
        MBItemState *itemState = [MBItemState itemStateWithDictionary:itemStateData];
        [[state inventory] addObject:itemState];
    }
    
    [state setStamina:[NSDecimalNumber decimalNumberWithString:dictionary[@"stamina"]]];
    [state setMaxStamina:[NSDecimalNumber decimalNumberWithString:dictionary[@"maxStamina"]]];
    
    return state;
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    [dictionary setObject:[NSMutableDictionary new] forKey:@"party"];
    [dictionary setObject:[NSMutableDictionary new] forKey:@"inventory"];
    [dictionary setObject:[[self stamina] stringValue] forKey:@"stamina"];
    [dictionary setObject:[[self maxStamina] stringValue] forKey:@"maxStamina"];
    
    for (MBPlayableCharacterState *state in [self party]) {
        [dictionary[@"party"] addObject:[state asDictionary]];
    }
    
    for (MBItemState *state in [self inventory]) {
        [dictionary[@"inventory"] addObject:[state asDictionary]];
    }
    
    return dictionary;
}

@end
