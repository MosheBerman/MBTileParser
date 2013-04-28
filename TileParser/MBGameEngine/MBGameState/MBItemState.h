//
//  MBItemState.h
//  TileParser
//
//  Created by Moshe Berman on 2/21/13.
//
//

#import <Foundation/Foundation.h>

@interface MBItemState : NSObject <NSCoding>

@property (nonatomic, assign) NSNumber *identifier;     //  Global ID of the item
@property (nonatomic, strong) NSString *itemName;    //  The item's name in menus and dialogs
@property (nonatomic, strong) NSString *spriteName;     //  The name of the sprite for the map
@property (nonatomic, strong) NSString *alternateSpriteName;     //  A second sprite, used in menus
@property (nonatomic, assign) CGPoint originInMapTiles;
@property (nonatomic, strong) NSNumber *quantity;       //  How many units the given item is worth
@property (nonatomic, assign) BOOL isCollected;         //  Has the item been collected?

@end
