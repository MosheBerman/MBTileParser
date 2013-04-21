//
//  MBItemState.h
//  TileParser
//
//  Created by Moshe Berman on 2/21/13.
//
//

#import <Foundation/Foundation.h>

@interface MBItemState : NSObject


@property (nonatomic, assign) long identifier;          //  Global ID of the item
@property (nonatomic, strong) NSString *displayName;    //  The item's name in menus and dialogs
@property (nonatomic, strong) NSString *spriteName;     //  The name of the sprite for the item
@property (nonatomic, strong) NSNumber *quantity;       //  How many units the given item is worth
@property (nonatomic, assign) BOOL isCollected;         //  Has the item been collected?

@end
