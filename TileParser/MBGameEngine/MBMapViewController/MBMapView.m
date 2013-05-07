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
@property (nonatomic, copy) NSString *keyForFollowedSprite;
@property (nonatomic, strong) NSMutableArray *layers;

@end

@implementation MBMapView

- (id)init{
    
    self = [super init];

    if (self) {
        
        //
        //  Sprite support
        //
        
        _sprites = [@{} mutableCopy];
        
        //
        //  Keep an array around for our layers
        //
        
        _layers = [@[] mutableCopy];
        
        //
        //  Add zoom support
        //
        
        _zoomWrapper = [UIView new];
        
        self.delegate = self;
        
        //
        //  Configure the map view
        //
        
        [self setAutoresizingMask: (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];;
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
    }
    
    return self;
}

- (void)loadMap:(MBMap *)map{
    
    [self setMap:map];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self buildCache];
    [self layoutMap];
}

//
//  Build a cache of UIImage objects from the tilesets
//

- (void)buildCache{
    
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
                    
                    //  ARC doesn't handle Core Graphics allocation functions except in special circumstances. This isn't one of them.
                    CGImageRelease(image);
                    
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

- (void)layoutMap{

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
                [[self layers] addObject:layer];
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
    
    MBLayerView * layer = [[self layers] objectAtIndex:0];
    
    [[self zoomWrapper] setFrame: layer.frame];
    
    [self setContentSize: [[self zoomWrapper] frame].size];
    
    //
    //  Add the zoom wrapper
    //
    
    [self addSubview:self.zoomWrapper];

}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
	return [self zoomWrapper];
}

#pragma mark - Add/Remove Sprites

- (void)addSprite:(MBSpriteView *)sprite forKey:(NSString *)key atTileCoordinates:(CGPoint)coords beneathLayerNamed:(NSString*)layerName{

    MBLayerView *layer = [self layerNamed:layerName];
    
    [self setSprite:sprite forKey:key];
    
    if(layer){
        [[self zoomWrapper] insertSubview:sprite belowSubview:layer];
    }else{
        [[self zoomWrapper] addSubview:sprite];
    }
    
    [self moveSpriteForKey:key toTileCoordinates:coords animated:NO duration:0];
}

- (void)removeSpriteForKey:(NSString*)key{
    [self.sprites removeObjectForKey:key];
}

#pragma mark - Private Sprite Methods

- (void)setSprite:(MBSpriteView *)sprite forKey:(NSString *)key{
    [[self sprites] setObject:sprite forKey:key];
}

- (MBSpriteView *)spriteForKey:(NSString *)key{
    return [self.sprites objectForKey:key];
}

#pragma mark - Move Sprites

//  Calls moveSpriteForKey:toTileCoordinates:duration:completion: with a nil completion block.
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

#pragma mark - Follow a sprite

- (void)beginFollowingSpriteForKey:(NSString *)key{
    
    if ([self keyForFollowedSprite]) {
        [self stopFollowingSpriteForKey:key];
    }
    
    [[self spriteForKey:key] addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self setKeyForFollowedSprite:key];
    
    if ([self bounds].size.width == 0 && [self bounds].size.height == 0) {
        [self setBounds:[[self superview] bounds]];
    }
    
    [self centerOnSpriteView:[self spriteForKey:[self keyForFollowedSprite]]];
}

- (void)stopFollowingSpriteForKey:(NSString *)key{
    [[self spriteForKey:key] removeObserver:self forKeyPath:@"frame"];
    [self setKeyForFollowedSprite:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isEqual:[self spriteForKey:[self keyForFollowedSprite]]] && [keyPath isEqual:@"frame"]) {
        [self centerOnSpriteView:[self spriteForKey:[self keyForFollowedSprite]]];
    }
}

- (void)centerOnSpriteView:(MBSpriteView *)spriteView{
    
    if(!spriteView){
        return;
    }
    
    CGSize size = self.bounds.size;
    CGPoint offset = [spriteView frame].origin;
    
    offset.x -= size.width/2;
    offset.y -= size.height/2;
    
    offset.x = MIN(self.contentSize.width-self.bounds.size.width, MAX(0, offset.x));
    offset.y = MIN(self.contentSize.height-self.bounds.size.height, MAX(0, offset.y));
    
    [self setContentOffset:offset];
}

- (void) refocusOnSprite{
    [self centerOnSpriteView:[self spriteForKey:[self keyForFollowedSprite]]];
}

- (BOOL)isFollowingSprite{
    return [self keyForFollowedSprite] != nil;
}

#pragma mark - Layer Accessor

- (MBLayerView *)layerNamed:(NSString *)name{
    
    for (MBLayerView *layer in [self layers]) {
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
