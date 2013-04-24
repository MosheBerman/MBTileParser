//
//  MBSpriteState.m
//  TileParser
//
//  Created by Moshe Berman on 2/21/13.
//
//

#import "MBCharacterState.h"

@interface MBCharacterState ()

@end

@implementation MBCharacterState

- (id)init
{
    self = [super init];
    if (self) {
        _direction = MBSpriteMovementDirectionDown;
        _originInTiles = CGPointMake(0, 0);
        _name = @"Malcolm";
        _dialog = [MBDialogTree new];
    }
    return self;
}

+ (MBCharacterState *)characterStateWithDictionary:(NSDictionary *)dictionary
{
    MBCharacterState *state = [MBCharacterState new];
    
    [state setDirection:[dictionary[@"direction"] integerValue]];
    [state setOriginInTiles:CGPointFromString(dictionary[@"originInTiles"])];
    [state setName:dictionary[@"name"]];
    [state setDialog:dictionary[@"dialog"]];
    
    //  TODO: Dialog dict?
    
    return state;
    
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    [dictionary setObject:@([self direction]) forKey:@"direction"];
    [dictionary setObject:NSStringFromCGPoint([self originInTiles]) forKey:@"originInTiles"];
    [dictionary setObject:[self name] forKey:@"name"];
    [dictionary setObject:[self dialog] forKey:@"dialog"];
    return dictionary;
}

@end
