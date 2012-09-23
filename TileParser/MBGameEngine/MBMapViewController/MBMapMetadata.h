//
//  MBMapDataProtocol.h
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import <Foundation/Foundation.h>

@protocol MBMapMetadata <NSObject>

- (NSDictionary *)propertiesForObjectInGroupNamed:(NSString *) atPoint:(CGPoint)points;
- (NSDictionary *)propertiesForTileInLayer:(NSString *)layerName atCoordinates:(CGPoint)coordinates;
- (CGSize)tileSizeInPoints;


@end
