//
//  MBTileSet.m
//  TileParser
//
//  Created by Moshe Berman on 8/15/12.
//
//

#import "MBTileSet.h"

@implementation MBTileSet

- (CGSize)mapSize{
    return CGSizeMake(_width, _height);
}

- (CGSize)tileSize{
    return CGSizeMake(_tileWidth, _tileHeight);
}

@end
