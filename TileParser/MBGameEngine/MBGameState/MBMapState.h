//
//  MBMapState.h
//  TileParser
//
//  Created by Moshe Berman on 4/21/13.
//
//

#import <Foundation/Foundation.h>

@interface MBMapState : NSObject <NSCoding>

@property (nonatomic, strong) NSString *mapName;        // The name of the map.
@property (nonatomic, strong) NSString *displayName;    // The display name of the map.
@property (nonatomic, strong) NSMutableArray *characterStates; // An array of MBCharacterState objects.
@property (nonatomic, strong) NSMutableArray *itemStates;      // An array of MBItemState objects.

@end
