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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _identifier = [aDecoder decodeObjectForKey:@"identifier"];
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _originInMapTiles = [aDecoder decodeCGPointForKey:@"originInMapTiles"];
        _spriteName = [aDecoder decodeObjectForKey:@"spriteName"];
        _alternateSpriteName = [aDecoder decodeObjectForKey:@"alternateSpriteName"];
        _quantity = [aDecoder decodeObjectForKey:@"quantity"];
        _isCollected = [aDecoder decodeBoolForKey:@"isCollected"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self identifier] forKey:@"identifier"];
    [aCoder encodeObject:[self itemName] forKey:@"itemName"];
    [aCoder encodeCGPoint:[self originInMapTiles] forKey:@"originInMapTiles"];
    [aCoder encodeObject:[self spriteName] forKey:@"spriteName"];
    [aCoder encodeObject:[self alternateSpriteName] forKey:@"alternateSpriteName"];
    [aCoder encodeObject:[self quantity] forKey:@"quantity"];
    [aCoder encodeBool:[self isCollected] forKey:@"isCollected"];
}


@end
