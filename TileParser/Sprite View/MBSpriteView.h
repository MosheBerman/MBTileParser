//
//  MBSpriteView.h
//  TileParser
//
//  Created by Andrew Dudney on 8/16/12.
//
//

#import <UIKit/UIKit.h>

@interface MBSpriteView : UIImageView

- (id)initWithAnimations:(NSDictionary *)animations;
- (void)beginAnimation:(NSString *)animationID;
- (void)stopAnimation;

@end
