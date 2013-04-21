//
//  MBPlayerState.m
//  TileParser
//
//  Created by Moshe Berman on 4/21/13.
//
//

#import "MBPlayableCharacterState.h"

@implementation MBPlayableCharacterState

- (id)init
{
    self = [super init];
    if (self) {
        _party = [NSMutableArray new];
        _inventory = [NSMutableArray new];
        
        _maxStamina = [NSDecimalNumber decimalNumberWithString:@"100"];
        _stamina = _maxStamina;
    }
    
    return self;
}

@end
