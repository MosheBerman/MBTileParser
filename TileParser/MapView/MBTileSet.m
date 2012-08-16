//
//  MBTileSet.m
//  TileParser
//
//  Created by Moshe Berman on 8/15/12.
//
//

#import "MBTileSet.h"

@implementation MBTileSet

- (id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if (self) {
        
        //
        //  Number formatter for pulling numbers...
        //
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        _firstgid = [[formatter numberFromString:[dictionary objectForKey:@"firstgid"]] integerValue];
        
        //  GIDs can't be 0, so if the preceding line converted nil to 0,
        //  we're not in a valid tileset.
        
        if (_firstgid < 1) {
            NSLog(@"This isn't a valid tileset");
            // Blow up? 
        }
        
        _height = [[formatter numberFromString:[dictionary objectForKey:@"height"]] integerValue];
        
        _name = [dictionary objectForKey:@"name"];
        
        _source = [dictionary objectForKey:@"source"];
        
        _tileHeight = [[formatter numberFromString:[dictionary objectForKey:@"tileheight"]] integerValue];
        
        _tileWidth = [[formatter numberFromString:[dictionary objectForKey:@"tilewidth"]] integerValue];
        
        _width = [[formatter numberFromString:[dictionary objectForKey:@"width"]] integerValue];
        
        _tileProperties = [@{} mutableCopy];
        
    }
    
    return self;
    
}

#pragma mark - Convenience Accessors

- (CGSize)mapSize{
    return CGSizeMake(_width/_tileWidth, _height/_tileHeight);
}

- (CGSize) sourceSize{
    return CGSizeMake(self.mapSize.width * self.tileSize.width, self.mapSize.height * self.tileSize.height);
}

- (NSInteger) tileCount{
    return self.mapSize.width * self.mapSize.height;
}

- (CGSize)tileSize{
    return CGSizeMake(_tileWidth, _tileHeight);
}

#pragma mark - Description

- (NSString *)description{
    
    NSString * mapSize = NSStringFromCGSize(self.mapSize);
    NSString * tileSize = NSStringFromCGSize(self.tileSize);
    
    NSString *_description = [NSString stringWithFormat:@""
                              "firstgid = %i, "
                              "height = %i, "
                              "tileHeight = %i, "
                              "tileWidth = %i, "
                              "width = %i, "
                              "name = %@, "
                              "source = %@, "
                              "mapSize = %@, "
                              "tileSize = %@, "
                              "", _firstgid, _height, _tileHeight, _tileWidth, _width, _name, _source, mapSize, tileSize];
    
    return _description;
    
}

@end
