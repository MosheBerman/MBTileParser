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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _party = [aDecoder decodeObjectForKey:@"party"];
        _inventory = [aDecoder decodeObjectForKey:@"inventory"];
        
        _maxStamina = [aDecoder decodeObjectForKey:@"maxStamina"];
        _stamina = [aDecoder decodeObjectForKey:@"stamina"];
        
        _level = [aDecoder decodeObjectForKey:@"level"];
        _experience = [aDecoder decodeObjectForKey:@"experience"];
        _experienceForNextLevel = [aDecoder decodeObjectForKey:@"experienceForNextLevel"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:[self party] forKey:@"party"];
    [aCoder encodeObject:[self inventory] forKey:@"inventory"];
    
    [aCoder encodeObject:[self maxStamina] forKey:@"maxStamina"];
    [aCoder encodeObject:[self stamina] forKey:@"stamina"];
    
    [aCoder encodeObject:[self level] forKey:@"level"];
    [aCoder encodeObject:[self experience] forKey:@"experience"];
    [aCoder encodeObject:[self experienceForNextLevel] forKey:@"experienceForNextLevel"];
}

@end
