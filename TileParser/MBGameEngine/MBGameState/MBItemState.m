//
//  MBItemState.m
//  TileParser
//
//  Created by Moshe Berman on 2/21/13.
//
//

#import "MBItemState.h"

@implementation MBItemState

- (id)init
{
    self = [super init];
    if (self) {
        _identifier = @(0);
        _itemName = @"Malcolm's iPhone";
        _originInMapTiles = CGPointZero;
        _spriteName = @"item";
        _alternateSpriteName = @"menuItem";
        _quantity = @(1);
        _isCollected = NO;
    }
    return self;
}

+ (MBItemState *)itemStateWithDictionary:(NSDictionary *)dictionary
{
    
    MBItemState *state = [MBItemState new];
    
    [state setIdentifier:dictionary[@"identifier"]];
    [state setItemName:dictionary[@"itemName"]];
    CGPoint origin = CGPointFromString(dictionary[@"originInMapTiles"]);
    [state setOriginInMapTiles:origin];
    [state setSpriteName:dictionary[@"spriteName"]];
    [state setAlternateSpriteName:dictionary[@"alternateSpriteName"]];
    [state setQuantity:dictionary[@"quantity"]];
    [state setIsCollected:[dictionary[@"isCollected"] boolValue]];
    
    return state;
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    [dictionary setObject:[self identifier] forKey:@"identifier"];
    [dictionary setObject:[self itemName] forKey:@"itemName"];
    [dictionary setObject:NSStringFromCGPoint([self originInMapTiles]) forKey:@"originInMapTiles"];
    [dictionary setObject:[self spriteName] forKey:@"spriteName"];
    [dictionary setObject:[self alternateSpriteName] forKey:@"alternateSpriteName"];
    [dictionary setObject:[self quantity] forKey:@"quantity"];
    [dictionary setObject:@([self isCollected]) forKey:@"isCollected"];
    
    return dictionary;
}

@end
