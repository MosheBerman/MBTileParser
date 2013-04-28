//
//  MBDialogTree.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "MBDialogTreeNode.h"

@interface MBDialogTreeNode () <NSCoding>
@property (nonatomic, assign) NSUInteger currentDialogIndex;
@end

@implementation MBDialogTreeNode

- (id)init{
    self = [super init];
    
    if (self) {
        _currentDialogIndex = 0;
        _dialog = nil;
        _displayName = @"New Dialog";
        _endAction = nil;
        
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _currentDialogIndex = [aDecoder decodeIntegerForKey:@"currentDialogIndex"];
        _dialog = [aDecoder decodeObjectForKey:@"dialog"];
    }
    
    return self;
}

- (BOOL) hasNext{
    return _currentDialogIndex < [[self dialog] count];
}

- (NSString *)nextStringToDisplay{
    NSString *next = [self dialog][_currentDialogIndex];
    _currentDialogIndex++;
    return next;
}

- (void)rewind {
    _currentDialogIndex = 0;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:[self currentDialogIndex] forKey:@"currentDialogIndex"];
    [aCoder encodeObject:[self dialog] forKey:@"dialog"];
}



@end
