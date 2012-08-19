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

//  If the layer doesn't exist, the view is inserted at the top
- (void) addSprite:(MBSpriteView *)sprite forKey:(NSString *)key atTileCoordinates:(CGPoint)coords beneathLayerNamed:(NSString*)layerName;
- (void) moveSpriteForKey:(NSString *)key toTileCoordinates:(CGPoint)coords animated:(BOOL)animated;
- (void) removeSpriteForKey:(NSString*) key;

@end
