//
//  MBMapObjectGroup.m
//  TileParser
//
//  Created by Moshe Berman on 8/16/12.
//
//

#import "MBMapObjectGroup.h"

@implementation MBMapObjectGroup

- (id)init{
    self = [super init];
    
    if (self) {
        _mapObjects = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id) lastObject{
    return [self.mapObjects lastObject];
}

- (id) objectAtIndex:(NSInteger)index{
    return [self.mapObjects objectAtIndex:index];
}

- (CGSize)sizeInTiles{
    return CGSizeMake(self.width, self.height);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@", self.mapObjects];
}

@end
