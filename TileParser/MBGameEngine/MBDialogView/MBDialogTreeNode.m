//
//  MBDialogTree.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "MBDialogTreeNode.h"

@interface MBDialogTreeNode ()
@property (nonatomic, assign) NSUInteger currentDialogIndex;
@end

@implementation MBDialogTreeNode

- (id)init{
    self = [super init];
    
    if (self) {
        _currentDialogIndex = 0;
    }
    
    return self;
}

- (BOOL) hasNext{
    return _currentDialogIndex < [[self dialog] count]-1;
}

- (NSString *)nextStringToDisplay {
    NSString *next = [self dialog][_currentDialogIndex];
    _currentDialogIndex++;
    return next;
}

- (void)rewind {
    _currentDialogIndex = 0;
}

@end
