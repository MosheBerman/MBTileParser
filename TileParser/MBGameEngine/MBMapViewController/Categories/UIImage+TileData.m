//
//  UIImage+TileData.m
//  TileParser
//
//  Created by Moshe Berman on 8/16/12.
//
//

#import "UIImage+TileData.h"

#import <objc/runtime.h>

static char *kTileDataKey = "tileData";

@implementation UIImage (TileData)

- (void)setTileData:(NSDictionary *)properties{
    objc_setAssociatedObject(self, &kTileDataKey, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)tileData{
    return objc_getAssociatedObject(self, &kTileDataKey);
}

@end
