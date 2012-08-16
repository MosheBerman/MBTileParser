//
//  MBWorld.h
//  TileParser
//
//  Created by Andrew Dudney on 8/15/12.
//
//

#import <Foundation/Foundation.h>

@class MBPlayer;

@interface MBWorld : NSObject

@property(nonatomic, copy) NSArray *maps;
@property(nonatomic, strong) MBPlayer *player;

@end
