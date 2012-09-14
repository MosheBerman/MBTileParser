//
//  UIImage+TileData.h
//  TileParser
//
//  Created by Moshe Berman on 8/16/12.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (TileData)

- (void)setTileData:(NSDictionary *)properties;
- (NSDictionary *)tileData;

@end
