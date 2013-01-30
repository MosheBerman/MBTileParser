//
//  MBTileSet.h
//  TileParser
//
//  Created by Moshe Berman on 8/15/12.
//
//

//
//  This class handles tilesets
//

#import <Foundation/Foundation.h>

@interface MBTileSet : NSObject

@property (nonatomic) NSInteger firstgid;       //  The first GID in the tileset
@property (nonatomic) NSInteger height;         //  Overall height of the associated image in pixels
@property (nonatomic) NSInteger tileHeight;     //  The height of a single tile in pixels
@property (nonatomic) NSInteger tileWidth;      //  The width of a single tile in pixels
@property (nonatomic) NSInteger width;          //  Overall width of the associated image in pixels

@property (nonatomic, copy) NSString *name;     //  The name of the tileset
@property (nonatomic, copy) NSString *source;   //  The path of the source image

@property (nonatomic, strong) NSMutableDictionary *tileProperties; //   Dictionary of dictionaries.

@property (nonatomic, readonly) CGSize mapSize;         //  The pixel dimensions of the source image
@property (nonatomic, readonly) CGSize sourceSize;      //  The pixel dimensions of the source image, by multiplying things
@property (nonatomic, readonly) NSInteger tileCount;    //  The number of tiles in a tileset, by multiplication
@property (nonatomic, readonly) CGSize tileSize;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)description;
@end
