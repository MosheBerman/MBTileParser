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

- (id)init;
- (void) loadMap:(MBMap *)map;

#pragma mark - Add/Remove Sprites

//  If the layer doesn't exist, the view is inserted at the top
- (void) addSprite:(MBSpriteView *)sprite forKey:(NSString *)key atTileCoordinates:(CGPoint)coords beneathLayerNamed:(NSString*)layerName;
- (void) removeSpriteForKey:(NSString*) key;

#pragma mark - Move Sprites

- (void)moveSpriteForKey:(NSString *)key toTileCoordinates:(CGPoint)coords animated:(BOOL)animated duration:(NSTimeInterval)duration;

@end
