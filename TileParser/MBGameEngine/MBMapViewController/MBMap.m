//
//  MBMap.m
//  TileParser
//
//  Created by Moshe Berman on 8/17/12.
//
//

#import "MBMap.h"

@implementation MBMap

- (id)init{
    
    self = [super init];
    
    if(self){
        
        _layers = [@[] mutableCopy];
        
        _tilesets = [@[] mutableCopy];
        
        _tileCache = [@[] mutableCopy];
        
        _objectGroups = [@{} mutableCopy];
    }
    
    return self;
}

- (CGSize)dimensionsInTiles{
    NSDictionary *layerData = [self layers][0];
    NSUInteger height = [layerData[@"width"] integerValue];
    NSUInteger width  = [layerData[@"width"] integerValue];
    
    return CGSizeMake(width, height);
}

@end
