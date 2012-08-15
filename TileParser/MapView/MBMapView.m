//
//  MBMapView.m
//  TileParser
//
//  Created by Moshe Berman on 8/14/12.
//
//

#import "MBMapView.h"

#import "MBTileParser.h"

#import "MBLayerView.h"

@interface MBMapView ()
@property (nonatomic, strong) MBTileParser * parser;
@property (nonatomic, strong) NSMutableArray *layers;
@property (nonatomic, strong) NSMutableArray *tilesets;
@property (nonatomic, strong) NSMutableArray *imagecache;
@end

@implementation MBMapView

- (id)initWithFrame:(CGRect)frame mapName:(NSString*)name{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _parser = [[MBTileParser alloc] initWithMapName:name];
        
        if (_parser) {
            
            //
            //  Keep a weak reference to self to
            //  avoid retain cycle
            //
            
            __weak MBMapView *weakSelf = self;
            
            MBTileParserCompletionBlock block = ^{
                
                __strong MBMapView *strongSelf = weakSelf;
                
                
                [self buildCache];
                [strongSelf layoutMap];
            };
            
            [_parser setCompletionHandler:block];
            
            [_parser start];
            
        }
    }
    return self;
}

//
//  Build a cache of UIImage objects from the tilesets
//

- (void) buildCache{
    

    
}


//
//  Calculate the number of tiles in a given tileset
//

- (NSInteger) numberOfTiles:(NSDictionary *)tileset{
    
    //
    //  Create a formatter for properly converting numbers
    //
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    //
    //
    //
    
    NSInteger heightInPoints, widthInPoints, heightInTiles, widthInTiles, tileHeight, tileWidth;
    
    heightInPoints = [[formatter numberFromString:[tileset objectForKey:@"height"]] integerValue];
    widthInPoints = [[formatter numberFromString:[tileset objectForKey:@"width"]] integerValue];
    tileHeight = [[formatter numberFromString:[tileset objectForKey:@"tileheight"]] integerValue];
    tileWidth = [[formatter numberFromString:[tileset objectForKey:@"tileWidth"]] integerValue];
    
    heightInTiles = heightInPoints / tileHeight;
    widthInTiles = widthInPoints / tileWidth;
    
    return heightInTiles * widthInTiles;
    
}

//
//  Layout the map in the scroll view
//

- (void) layoutMap{
    
    //Safety check
    if (!self.parser) {
        return;
    }
    
    for (NSInteger i = self.layers.count; i > 0; i--) {
        
        NSDictionary *layerData = [self.layers objectAtIndex:i];
        
        MBLayerView *layer = [[MBLayerView alloc] initWithLayerData:layerData tilesets:self.tilesets imageCache:self.imagecache];
        
        [self addSubview:layer];
        
    }
}

@end
