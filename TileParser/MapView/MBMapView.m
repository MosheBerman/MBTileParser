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

#import "MBMapObjectGroup.h"

#import "UIImage+TileData.h"

#import "MBSpriteview.h"

@interface MBMapView () <UIScrollViewDelegate>
@property (nonatomic, strong) MBTileParser *parser;

@property (nonatomic, strong) NSMutableArray *layers;
@property (nonatomic, strong) NSMutableArray *tilesets;
@property (nonatomic, strong) NSMutableArray *tileCache;
@property (nonatomic, strong) NSMutableDictionary *objectGroups;
@property (nonatomic, strong) NSMutableDictionary *sprites;

@property (nonatomic, strong) UIView *zoomWrapper;
@end

@implementation MBMapView

- (id)initWithFrame:(CGRect)frame mapName:(NSString*)name{
    
    self = [super initWithFrame:frame];

    if (self) {
        
        // Initialization code
        
        _layers = [@[] mutableCopy];
        
        _tilesets = [@[] mutableCopy];
        
        _tileCache = [@[] mutableCopy];
        
        _objectGroups = [@{} mutableCopy];
        
        _sprites = [@{} mutableCopy];
        
        //
        //  Add zoom support
        //
        
        _zoomWrapper = [UIView new];
        
        self.delegate = self;
        
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
                
                
                NSMutableArray *objectGroups = [strongSelf.parser.mapDictionary objectForKey:@"objectGroups"];
                
                for (MBMapObjectGroup *objectGroup in objectGroups) {
                    [self.objectGroups setObject:objectGroup  forKey:objectGroup.name];
                }
                
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

                if ([[layer name] isEqualToString:@"Meta"]) {
                    layer.alpha = 0;
                }
                
                [[self zoomWrapper] addSubview:layer];
                [[self layers] replaceObjectAtIndex:i withObject:layer];
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
    
    CGRect frameOfFirstLayer = ((MBLayerView *)[self.layers objectAtIndex:0]).frame;
    
    [[self zoomWrapper] setFrame:frameOfFirstLayer];
    
    self.contentSize = [[self zoomWrapper] frame].size;
    
    //
    //
    //
    
    [self addSubview:self.zoomWrapper];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
	return [self zoomWrapper];
}

#pragma mark - Public Sprite Methods

- (void) addSprite:(MBSpriteView *)sprite forKey:(NSString *)key atTileCoordinates:(CGPoint)coords beneathLayerNamed:(NSString*)layerName{

    MBLayerView *layer = [self layerNamed:layerName];
    
    [self setSprite:sprite forKey:key];
    
    if(layer){
        [[self zoomWrapper] insertSubview:sprite belowSubview:layer];
    }else{
        [[self zoomWrapper] addSubview:sprite];
    }
    
    [self moveSpriteForKey:key toTileCoordinates:coords animated:YES];
    
}

//TODO: Add completion block, add animation support
- (void) moveSpriteForKey:(NSString *)key toTileCoordinates:(CGPoint)coords animated:(BOOL)animated{
    
    MBSpriteView * sprite = [self spriteForKey:key];
    MBTileSet *tileSet = self.tilesets[0];
    
    CGSize tileSize = tileSet.tileSize;
    
    coords.x = coords.x * tileSize.width;
    coords.y = coords.y * tileSize.height;
    
    CGSize spriteSize = sprite.frame.size;
    
    if (animated) {
        sprite.frame = CGRectMake(coords.x, coords.y, spriteSize.width, spriteSize.height);
    }else{
        sprite.frame = CGRectMake(coords.x, coords.y, spriteSize.width, spriteSize.height);
    }
}

- (void) removeSpriteForKey:(NSString*) key{
    [self.sprites removeObjectForKey:key];
}

#pragma mark - Private Sprite Methods

- (void) setSprite:(MBSpriteView *)sprite forKey:(NSString *)key{
    [[self sprites] setObject:sprite forKey:key];
}

- (MBSpriteView *) spriteForKey:(NSString *)key{
    return [self.sprites objectForKey:key];
}

#pragma mark - Layer Accessor

- (MBLayerView *)layerNamed:(NSString *)name{
   
    for (MBLayerView *layer in self.layers) {
        if ([[layer name] isEqualToString:name]) {
            return layer;
        }
    }
    
    return nil;
}
@end
