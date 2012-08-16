//
//  MBSpriteView.h
//  TileParser
//
//  Created by Andrew Dudney on 8/16/12.
//
//

#import <UIKit/UIKit.h>

@interface MBSpriteView : UIImageView

- (id)initWithFrame:(CGRect)frame spriteSheetName:(NSString *)spriteSheetName;
- (void)beginAnimation:(NSString *)animationID;
- (void)stopAnimation;

@end
