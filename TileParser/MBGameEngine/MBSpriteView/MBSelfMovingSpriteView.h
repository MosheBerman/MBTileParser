//
//  MBSelfMovingSpriteView.h
//  TileParser
//
//  Created by Moshe Berman on 9/7/12.
//
//

#import "MBMovableSpriteView.h"

@interface MBSelfMovingSpriteView : MBMovableSpriteView

- (void)moveInRandomDirection;
- (void)faceInRandomDirection;

@end
