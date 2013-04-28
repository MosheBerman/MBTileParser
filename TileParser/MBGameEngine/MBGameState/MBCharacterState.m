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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super init];
    if(self){
        _direction = [aDecoder decodeIntegerForKey:@"direction"];
        _originInTiles = [aDecoder decodeCGPointForKey:@"originInTiles"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _dialog = [aDecoder decodeObjectForKey:@"dialog"];
 
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:[self direction] forKey:@"direction"];
    [aCoder encodeCGPoint:[self originInTiles] forKey:@"originInTiles"];
    [aCoder encodeObject:[self name] forKey:@"name"];
    [aCoder encodeObject:[self dialog] forKey:@"dialog"];
}

@end
