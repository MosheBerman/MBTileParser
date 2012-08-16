//
//  MBLayerView.m
//  TileParser
//
//  Created by Moshe Berman on 8/14/12.
//
//

#import "MBLayerView.h"

#import "MBMapView.h"

#import "MBTileSet.h"

#import "MBTileView.h"

@interface MBLayerView ()
@property (nonatomic, strong) NSDictionary *layerData;
@property (nonatomic, strong) NSArray *tilesets;
@property (nonatomic, strong) NSArray *cache;
@end

@implementation MBLayerView

- (id)initWithLayerData:(NSDictionary *)data tilesets:(NSArray *)tilesets imageCache:(NSArray *)cache{
    
    //
    //  Read this out form the layer data. We only allow one tile size per layer,
    //  so if different tilesets have different tilesizes you're out of luck. We could
    //  try to fix this by finding the largest size, but it could adversely affect the
    //  smaller ones, so it makes no sense. Instead, grab the first tileset and use its
    //  tile dimensions.
    //
    
    MBTileSet *workingTileset = [tilesets objectAtIndex:0];
    
    //
    //  The number of tiles comes from the layer
    //
    
    NSInteger heightInTiles = [[data objectForKey:@"height"] integerValue];
    NSInteger widthInTiles = [[data objectForKey:@"height"] integerValue];
    
    NSInteger height = heightInTiles * workingTileset.tileSize.height;
    NSInteger width = widthInTiles * workingTileset.tileSize.width;
    
    //
    //  Since we're placing these in a scroll view, the origin should be zero.
    //  We shrink the UIScrollView to fit the largest one. TMX layers
    //  are all the same size.
    //
    
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    
    if (self) {
        
        _heightInTiles = heightInTiles;
        _widthInTiles = widthInTiles;
        
        _layerData = data;
        _tilesets = tilesets;
        _cache = cache;
        
        _name = [_layerData objectForKey:@"name"];
    }
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) drawMapLayer{
    
    
    //The list of tile IDs in the layer
    NSArray *gids = [self.layerData objectForKey:@"data"];
    
    //Obligatory number formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSInteger heightInTiles = [[formatter numberFromString:[self.layerData objectForKey:@"height"]] integerValue];
    NSInteger widthInTiles = [[formatter numberFromString:[self.layerData objectForKey:@"width"]] integerValue];
    
    
    //
    //  Grab the first tileset because they're all the same dimensions
    //
    
    MBTileSet *workingTileset = [self.tilesets objectAtIndex:0];
    
    //
    //  Finish prepping for the frame
    //
    
    CGSize tileSize = [workingTileset tileSize];
    
    NSInteger heightOfTile = tileSize.height;
    NSInteger widthOfTile = tileSize.width;
    
    for (NSInteger x = 0; x < widthInTiles; x++) {
        for (NSInteger y = 0; y < heightInTiles; y++) {
            
            @autoreleasepool {
                
                CGRect frame = CGRectMake(x*widthOfTile, y*heightOfTile, widthOfTile, heightOfTile);
                
                //
                // Calculate which tile we're using,
                //  add complete rows and then the tiles
                //  in the current row.
                //
                
                NSInteger tileIndex = (y * widthInTiles) + x;
                
                //
                //  Get the gid value, create the obligatory NSNumberFormatter
                //
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                
                NSInteger GID = [[formatter numberFromString:[gids objectAtIndex:tileIndex]] integerValue];
                
                //  Skip empty tiles
                if (GID == 0) {
                    continue;
                }
                
                //
                // Map the GID to the image in the array.
                // Aaaand since Arrays are zero based...
                // we need to decrement.
                //
                
                GID--;
                
                //  Pull a UIImage from the texture array
                UIImage *tileImage = [self.cache objectAtIndex:GID];
                
                //Put it into the tile
                UIImageView *tile = [[UIImageView alloc] initWithFrame:frame];
                [tile setImage:tileImage];
                [tile setOpaque:NO];
                [tile setBackgroundColor:[UIColor clearColor]];
                
                //Add the tile to self
                [self addSubview:tile];
            }
        }
    }
    
    //
    //  Set up the content view
    //
    
    NSInteger height = heightInTiles * tileSize.height;
    NSInteger width = widthInTiles * tileSize.width;
    
    self.frame = CGRectMake(0, 0, width, height);
    
}

@end
