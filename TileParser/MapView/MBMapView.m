//
//  MBMapView.m
//  TileParser
//
//  Created by Moshe Berman on 8/14/12.
//
//

#import "MBMapView.h"

#import "MBTileParser.h"

#import "MBTileSet.h"

#import "MBLayerView.h"

#import "UIImage+TileData.h"

@interface MBMapView ()
@property (nonatomic, strong) MBTileParser *parser;
@property (nonatomic, strong) NSMutableArray *layers;
@property (nonatomic, strong) NSMutableArray *tilesets;
@property (nonatomic, strong) NSMutableArray *tileCache;
@property (nonatomic, strong) NSMutableArray *objectGroup;
@end

@implementation MBMapView

- (id)initWithFrame:(CGRect)frame mapName:(NSString*)name{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _layers = [@[] mutableCopy];
        
        _tilesets = [@[] mutableCopy];
        
        _tileCache = [@[] mutableCopy];
        
        _objectGroup = [@[] mutableCopy];
        
        //
        //  Configure the map view
        //
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        _parser = [[MBTileParser alloc] initWithMapName:name];
        
        if (_parser) {
            
            //
            //  Keep a weak reference to self to
            //  avoid retain cycle
            //
            
            __weak MBMapView *weakSelf = self;
            
            MBTileParserCompletionBlock block = ^{
                
                __strong MBMapView *strongSelf = weakSelf;
                
                strongSelf.layers = [strongSelf.parser.mapDictionary objectForKey:@"layers"];
                strongSelf.tilesets = [strongSelf.parser.mapDictionary objectForKey:@"tilesets"];
                
                NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstgid" ascending:YES];
                [_tilesets sortUsingDescriptors:@[descriptor]];
                
                [strongSelf buildCache];
                
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
        
        //  First grab the set
        MBTileSet *workingSet = [self.tilesets objectAtIndex:i];
        
        NSString *source = [workingSet source];
        
        UIImage *tilesheet = [UIImage imageNamed:source];
        
        //
        //  Get the dimensions and tilesize of the tilesheet
        //
        
        CGSize dimensionsOfTileInSet = [workingSet tileSize];
        
        //
        //  Loop through the tilesheet now, chopping it up
        //
        
        //
        //  TODO: Load properties into the images from the tileset
        //
        
        for (NSInteger j = 0; j < workingSet.mapSize.height; j++) {
            for (NSInteger i = 0; i < workingSet.mapSize.width; i++) {
                
                @autoreleasepool {
                    
                    
                    CGRect tileRect = CGRectMake(dimensionsOfTileInSet.width * i, dimensionsOfTileInSet.height * j, dimensionsOfTileInSet.width, dimensionsOfTileInSet.height);
                    
                    //NSLog(@"Tilesheet image: %@", tilesheet);
                    
                    CGImageRef image = CGImageCreateWithImageInRect(tilesheet.CGImage, tileRect);
                    
                    //
                    //  TODO: Support actual scale
                    //
                    //  TODO: Support rotation - TMX supports this, so this would be where to add it.
                    //
                    
                    UIImage *tile = [UIImage imageWithCGImage:image scale:1.0 orientation:tilesheet.imageOrientation];
                    
                    [self.tileCache addObject:tile];
                    
                }
            }
        }
    }
}

//
//  Layout the map in the scroll view
//

- (void) layoutMap{
    
    //Safety check
    if (!self.parser) {
        return;
    }
    
    for (NSInteger i = 0; i < self.layers.count; i++) {
        
        //Reduces initial spike
        @autoreleasepool {
            NSDictionary *layerData = [self.layers objectAtIndex:i];
            
            MBLayerView *layer = [[MBLayerView alloc] initWithLayerData:layerData tilesets:self.tilesets imageCache:self.tileCache];
            
            if(layer){
                [layer drawMapLayer];

                if ([layer.name isEqualToString:@"Meta"]) {
                    layer.alpha = 0;
                }
                [self addSubview:layer];
                [self.layers replaceObjectAtIndex:i withObject:layer];
            }
        }
    }
    
    //
    //  Resize the contentSize to fit the layers.
    //  Since we assume that all layers are equally sized,
    //  we just grab the first layer's dimensions.
    //
    //  We could theoretically loop through the layers but
    //  it's a waste of time, as is this comment.
    //
    
    self.contentSize = ((MBLayerView *)[self.layers objectAtIndex:0]).frame.size;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
	return [self.layers objectAtIndex:1];
}

@end
