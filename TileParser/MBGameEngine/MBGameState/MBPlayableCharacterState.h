//
//  MBPlayableCharacterState.h
//  TileParser
//
//  Created by Moshe Berman on 4/21/13.
//
//

#import "MBCharacterState.h"

@interface MBPlayableCharacterState : MBCharacterState <NSCoding>

@property (nonatomic, strong) NSMutableArray *party;            //  The members of your party, contains instances of MBCharacterState.
@property (nonatomic, strong) NSMutableArray *inventory;        //  The items in your inventory.

@property (nonatomic, strong) NSDecimalNumber *stamina;
@property (nonatomic, strong) NSDecimalNumber *maxStamina;

@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSNumber *experience;
@property (nonatomic, strong) NSNumber *experienceForNextLevel;

@end