//
//  MBMapObjectGroup.h
//  TileParser
//
//  Created by Moshe Berman on 8/16/12.
//
//

#import <Foundation/Foundation.h>

#import "MBTileMapObject.h"

@interface MBMapObjectGroup : NSObject

@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;

@property (nonatomic, strong) NSMutableArray *mapObjects;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, readonly) CGSize sizeInTiles;

- (id) lastObject;
- (id) objectAtIndex:(NSInteger)index;

@end
