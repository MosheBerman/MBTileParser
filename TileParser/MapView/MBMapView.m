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
        
        _layers = [@[] mutableCopy];
        _tilesets = [@[] mutableCopy];
        _imagecache = [@[] mutableCopy];
        
        _parser = [[MBTileParser alloc] initWithMapName:name];
        
        if (_parser) {
            
            //
            //  Keep a weak reference to self to
            //  avoid retain cycle
            //
            
            __weak MBMapView *weakSelf = self;
            
            MBTileParserCompletionBlock block = ^{
                
                __strong MBMapView *strongSelf = weakSelf;
                
                NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstgid" ascending:YES];
                [_tilesets sortUsingDescriptors:@[descriptor]];
                
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

    //
    //  Assume the layers are sorted by lowest firstgid
    //
    
    for (NSInteger i = 0; i < self.tilesets.count;i++) {
        
        //
        //  Break up the larger image into UIImages
        //
        
        //  First
        NSDictionary *workingSet = [self.tilesets objectAtIndex:i];

        NSString *source = [workingSet objectForKey:@"source"];
        
        UIImage *tilesheet = [UIImage imageNamed:source];
        
        //
        //  Get the dimensions and tilesize of the tilesheet
        //
        
        CGSize dimensionsOfTilesheet = [self dimensionsOfSet:workingSet];
        CGSize dimensionsOftileInSet = [self dimensionsOftileInSet:workingSet];
        
        //
        //  Loop through the tilesheet now, chopping it up
        //
        
        for (NSInteger i = 0; i < dimensionsOfTilesheet.width; i++) {
            for (NSInteger j = 0; i < dimensionsOfTilesheet.height; j++) {
             
                //  Get the tile in the row
                NSInteger rowIndex = i % (NSInteger)dimensionsOfTilesheet.width;
                
                CGRect tileRect = CGRectMake(dimensionsOftileInSet.width * rowIndex, dimensionsOftileInSet.height * j, dimensionsOftileInSet.width, dimensionsOftileInSet.height);
                
                CGImageRef image = CGImageCreateWithImageInRect(tilesheet.CGImage, tileRect);
                
                //
                //  TODO: Support actual scale
                //
                //  TODO: Support rotation - TMX supports this, so this would be where to add it.
                //
                
                UIImage *tile = [UIImage imageWithCGImage:image scale:1.0 orientation:tilesheet.imageOrientation];
                
                [self.imagecache addObject:tile];
                
            }
        }
        
        
    }
    
    
}

//
//  Calculate the dimensions of a tileset
//

- (CGSize) dimensionsOfSet:(NSDictionary *)tileset{
    
    //
    //  Create a formatter for properly converting numbers
    //
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    //
    //  Calculate *ALL* the things!
    //
    
    NSInteger heightInPoints, widthInPoints, tileHeight, tileWidth;
    
    heightInPoints = [[formatter numberFromString:[tileset objectForKey:@"height"]] integerValue];
    widthInPoints = [[formatter numberFromString:[tileset objectForKey:@"width"]] integerValue];
    tileHeight = [[formatter numberFromString:[tileset objectForKey:@"tileheight"]] integerValue];
    tileWidth = [[formatter numberFromString:[tileset objectForKey:@"tileWidth"]] integerValue];
    
    //
    //  Return the dimensions as a CGSize
    //
    
    return CGSizeMake(widthInPoints / tileWidth, heightInPoints / tileHeight);
}

//
//  Calculate the dimensions of a tileset
//

- (CGSize) dimensionsOftileInSet:(NSDictionary *)tileset{
    
    //
    //  Create a formatter for properly converting numbers
    //
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    //
    //  Calculate *ALL* the things!
    //
    
    NSInteger tileHeight, tileWidth;

    tileHeight = [[formatter numberFromString:[tileset objectForKey:@"tileheight"]] integerValue];
    tileWidth = [[formatter numberFromString:[tileset objectForKey:@"tileWidth"]] integerValue];
    
    //
    //  Return the dimensions as a CGSize
    //
    
    return CGSizeMake(tileWidth, tileHeight);
}



//
//  Calculate the number of tiles in a given tileset
//

- (NSInteger) numberOfTilesInSet:(NSDictionary *)tileset{

    CGSize dimensions = [self dimensionsOfSet:tileset];
    
    return dimensions.height * dimensions.width;
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
