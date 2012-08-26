//
//  MBMapView.m
//  TileParser
//
//  Created by Moshe Berman on 8/14/12.
//
//

#import "MBMapView.h"

#import "MBTileSet.h"

#import "MBLayerView.h"

#import "MBMapObjectGroup.h"

#import "UIImage+TileData.h"

#import "MBMap.h"

@interface MBMapView () <UIScrollViewDelegate>

@property (nonatomic, strong) MBMap *map;

@property (nonatomic, strong) UIView *zoomWrapper;

@end

@implementation MBMapView

- (id)init{
    
    self = [super init];

    if (self) {
        
        // Initialization code
        
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
        

    }
    return self;
}

- (void) loadMap:(MBMap *)map{
    
    self.map = map;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self buildCache];
    [self layoutMap];
}

//
//  Build a cache of UIImage objects from the tilesets
//

- (void) buildCache{
    
    //
    //  Assume the layers are sorted by lowest firstgid
    //
    
    for (NSInteger i = 0; i < self.map.tilesets.count;i++) {
        
        //
        //  Break up the larger image into UIImages
        //
        
        //  First grab the set
        MBTileSet *workingSet = [[[self map] tilesets] objectAtIndex:i];
        
        NSString *source = [workingSet source];
        
        UIImage *tilesheet = [UIImage imageNamed:source];
        
        //
        //  Get the dimensions and tilesize of the tilesheet
        //
        
        CGSize dimensionsOfTileInSet = [workingSet tileSize];
        
        //
        //  A reference to the cache
        //
        
        NSMutableArray *cache = self.map.tileCache;
        
        //
        //  Loop through the tilesheet now, chopping it up
        //
        
        for (NSInteger j = 0; j < workingSet.mapSize.height; j++) {
            for (NSInteger k = 0; k < workingSet.mapSize.width; k++) {
                
                @autoreleasepool {
                    
                    CGRect tileRect = CGRectMake(dimensionsOfTileInSet.width * k, dimensionsOfTileInSet.height * j, dimensionsOfTileInSet.width, dimensionsOfTileInSet.height);
                    
                    //NSLog(@"Tilesheet image: %@", tilesheet);
                    
                    CGImageRef image = CGImageCreateWithImageInRect(tilesheet.CGImage, tileRect);
                    
                    //
                    //  TODO: Support actual scale
                    //
                    //  TODO: Support rotation - TMX supports this, so this would be where to add it.
                    //
                    
                    UIImage *tile = [UIImage imageWithCGImage:image scale:1.0 orientation:tilesheet.imageOrientation];
                    
                    //
                    //  TODO: Load properties into the images from the tileset
                    //
                    
                    if ([[workingSet tileProperties] allKeys].count) {
                        
                        NSInteger index =  (j*workingSet.mapSize.width)+k;
                        
                        NSNumber *key = [NSNumber numberWithInteger:index];
                        
                        NSDictionary *tileProperties = [workingSet tileProperties];
                    
                        [tile setTileData:tileProperties[key]];
                    }
                    
                    
                    [cache addObject:tile];
                }
            }
        }
    }
}

//
//  Layout the map in the scroll view
//

- (void) layoutMap{

    for (NSInteger i = 0; i < self.map.layers.count; i++) {
        
        //Reduces initial spike
        @autoreleasepool {
            NSDictionary *layerData = [self.map.layers objectAtIndex:i];
            
            MBLayerView *layer = [[MBLayerView alloc] initWithLayerData:layerData tilesets:self.map.tilesets imageCache:self.map.tileCache];
            
            if(layer){
                [layer drawMapLayer];

                if ([[layer name] isEqualToString:@"Meta"]) {
                    layer.alpha = 0;
                }
                
                [[self zoomWrapper] addSubview:layer];
                [[self.map layers] replaceObjectAtIndex:i withObject:layer];
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
    
    MBLayerView * layer = [[self.map layers] objectAtIndex:0];
    
    [[self zoomWrapper] setFrame: layer.frame];
    
    [self setContentSize: [[self zoomWrapper] frame].size];
    
    //
    //  Add the zoom wrapper
    //
    
    [self addSubview:self.zoomWrapper];

}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
	return [self zoomWrapper];
}

#pragma mark - Add/Remove Sprites

- (void) addSprite:(MBSpriteView *)sprite forKey:(NSString *)key atTileCoordinates:(CGPoint)coords beneathLayerNamed:(NSString*)layerName{

    MBLayerView *layer = [self layerNamed:layerName];
    
    [self setSprite:sprite forKey:key];
    
    if(layer){
        [[self zoomWrapper] insertSubview:sprite belowSubview:layer];
    }else{
        [[self zoomWrapper] addSubview:sprite];
    }
    
    [self moveSpriteForKey:key toTileCoordinates:coords animated:NO duration:0];
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

#pragma mark - Move Sprites

//TODO: Add completion block, add animation support

- (void)moveSpriteForKey:(NSString *)key toTileCoordinates:(CGPoint)coords animated:(BOOL)animated duration:(NSTimeInterval)duration{
    [self moveSpriteForKey:key toTileCoordinates:coords animated:animated duration:duration completion:nil];
}

- (void)moveSpriteForKey:(NSString *)key toTileCoordinates:(CGPoint)coords animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion{
    MBSpriteView * sprite = [self spriteForKey:key];
    MBTileSet *tileSet = self.map.tilesets[0];
    
    CGSize tileSize = tileSet.tileSize;
    
    coords.x = coords.x * tileSize.width;
    coords.y = coords.y * tileSize.height;
    
    CGSize spriteSize = sprite.frame.size;
    
    if (animated) {
        [UIView
         animateWithDuration:duration
         animations:^{
             sprite.frame = CGRectMake(coords.x, coords.y, spriteSize.width, spriteSize.height);
         }
         completion:completion];
        
    }else{
        sprite.frame = CGRectMake(coords.x, coords.y, spriteSize.width, spriteSize.height);
    }
}

#pragma mark - Layer Accessor

- (MBLayerView *)layerNamed:(NSString *)name{
    
    for (MBLayerView *layer in self.map.layers) {
        if ([[layer name] isEqualToString:name]) {
            return layer;
        }
    }
    
    return nil;
}

- (UIImage *)tileAtCoordinates:(CGPoint)coordinates inLayerNamed:(NSString *)layerName{

    MBLayerView *layer = [self layerNamed:@"Meta"];
    
    UIImage *tileImage = [layer tileAtCoordinates:coordinates];
    
    return tileImage;
    
}

@end
