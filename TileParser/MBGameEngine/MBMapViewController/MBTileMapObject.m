//
//  MBTileMapObject.m
//  TileParser
//
//  Created by Moshe Berman on 8/16/12.
//
//

#import "MBTileMapObject.h"

@implementation MBTileMapObject

- (id) init{
    
    self = [super init];
    
    if (self) {
        
        _properties = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"X: %li Y: %li Width: %li Height: %li Properties: %@", (long)self.x, (long)self.y, (long)self.width, (long)self.height, self.properties];
}

@end
