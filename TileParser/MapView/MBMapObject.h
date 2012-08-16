//
//  MBMapObject.h
//  TileParser
//
//  Created by Moshe Berman on 8/16/12.
//
//

#import <Foundation/Foundation.h>

@interface MBMapObject : NSObject

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;

@property (nonatomic, strong) NSMutableDictionary *properties;

@end
