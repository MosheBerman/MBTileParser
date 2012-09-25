//
//  MBMap.h
//  TileParser
//
//  Created by Moshe Berman on 8/17/12.
//
//

#import <Foundation/Foundation.h>

@interface MBMap : NSObject

@property (nonatomic, strong) NSMutableArray *layers;
@property (nonatomic, strong) NSMutableArray *tilesets;
@property (nonatomic, strong) NSMutableArray *tileCache;
@property (nonatomic, strong) NSMutableDictionary *objectGroups;

@property (nonatomic, readonly) CGSize dimensionsInTiles;
@end
