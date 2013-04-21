//
//  MBSpriteState.m
//  TileParser
//
//  Created by Moshe Berman on 2/21/13.
//
//

#import "MBCharacterState.h"

@implementation MBCharacterState

- (id)init
{
    self = [super init];
    if (self) {
        _direction = MBSpriteMovementDirectionDown;
        _originInTiles = CGPointMake(0, 0);
        _name = @"Malcolm";
        _dialog = [MBDialogTree new];
    }
    return self;
}

@end
