//
//  MBMapView.h
//  TileParser
//
//  Created by Moshe Berman on 8/14/12.
//
//

#import <UIKit/UIKit.h>

#import "MBSpriteView.h"

#import "MBMap.h"

@interface MBMapView : UIScrollView

@property (nonatomic, strong) NSMutableDictionary *sprites;
@property (readonly, nonatomic, assign) BOOL isFollowingSprite;

- (id)init;
- (void)loadMap:(MBMap *)map;

//  Insert a sprite beneath a layer
//  If the layer doesn't exist or if the parameter is nil, the view is inserted at the top
- (void)addSprite:(MBSpriteView *)sprite forKey:(NSString *)key atTileCoordinates:(CGPoint)coords beneathLayerNamed:(NSString*)layerName;

//Remove a given sprite from the map
- (void)removeSpriteForKey:(NSString*)key;

//  Returns the tile in a given layer at a given coordinate
- (UIImage *)tileAtCoordinates:(CGPoint)coordinates inLayerNamed:(NSString *)layerName;

//  Assigns a target to follow
- (void)beginFollowingSpriteForKey:(NSString *)key;

//  Removes target to follow
- (void)stopFollowingSpriteForKey:(NSString *)key;

//  Center on the sprite that's being followed. Use after orientation or other frame changes.
- (void) refocusOnSprite;

@end
