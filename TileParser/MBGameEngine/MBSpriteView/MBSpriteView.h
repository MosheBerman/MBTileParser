//
//  MBSpriteView.h
//  TileParser
//
//  Created by Andrew Dudney on 8/16/12.
//
//

#import <UIKit/UIKit.h>

@interface MBSpriteView : UIImageView

@property (readonly, nonatomic, strong) NSDictionary *animations;

//  Initializer
- (id)initWithSpriteName:(NSString *)name;

//  Animation playback control methods
- (void)beginAnimationWithKey:(NSString *)animationID;
- (void)stopAnimation;

// Set the image to the first frame of a given animation
- (void)setActiveAnimation:(NSString *)direction;


@end
