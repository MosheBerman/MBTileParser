//
//  MBMapView.h
//  TileParser
//
//  Created by Moshe Berman on 8/14/12.
//
//

#import <UIKit/UIKit.h>

@class MBSpriteView;

@interface MBMapView : UIScrollView

- (id)initWithFrame:(CGRect)frame mapName:(NSString*)name;

- (void) addSprite:(MBSpriteView *)sprite forKey:(NSString *)key atTileCoordinates:(CGPoint)coords;
- (void) moveSpriteForKey:(NSString *)key toTileCoordinates:(CGPoint)coords animated:(BOOL)animated;
- (void) removeSpriteForKey:(NSString*) key;

@end
