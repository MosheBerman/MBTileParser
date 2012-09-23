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
    return [NSString stringWithFormat:@"X: %i Y: %i Width: %i Height: %i Properties: %@", self.x, self.y, self.width, self.height, self.properties];
}

@end
