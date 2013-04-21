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

@end
