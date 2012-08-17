//
//  MBSpriteParser.h
//  TileParser
//
//  Created by Andrew Dudney on 8/16/12.
//
//

#import <Foundation/Foundation.h>

@class MBSpriteView;

@interface MBSpriteParser : NSObject

//
//  Returns an instance of MBSpriteParser, nil if the data can't load.
//

+ (MBSpriteView *)spriteViewWithSpriteName:(NSString *)name;

@end
