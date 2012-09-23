//
//  MBDialogTree.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "MBDialogTree.h"

@implementation MBDialogTree

- (id) initWithContentsOfArray:(NSArray *)array{
 
    self = [super init];
    
    if (self) {
        _nodes = array;
        _firstNode = array[0];
        _activeNode = _firstNode;
    }
    
    return self;
}

- (id) initWithMessage:(NSString *)dialogText{
    
    MBDialogTreeNode *node = [[MBDialogTreeNode alloc] init];
    [node setDialog:@[dialogText]];
    return [self initWithContentsOfArray:@[node]];
}

- (id) initWithContentsOfFile:(NSString *)path{
    NSArray *dialogNodes = [NSArray arrayWithContentsOfFile:path];
    return [self initWithContentsOfArray:dialogNodes];
}

- (id) initWithContentsOfURL:(NSURL *)url{
    NSArray *dialogNodes = [NSArray arrayWithContentsOfURL:url];
    return [self initWithContentsOfArray:dialogNodes];
}

- (NSUInteger) currentNode{
    return [[self nodes] indexOfObject:[self activeNode]];
}

- (BOOL) hasNext{
    if (![self activeNode] || ![[self nodes] count]) {
        return NO;
    }
    return [self currentNode] < [[self nodes] count];
}

- (MBDialogTreeNode *)nextNode{
    
    if (![self hasNext]) {
        return nil;
    }

    NSUInteger indexOfNext =[self currentNode] +1;
    MBDialogTreeNode *newNext = [self nodes][indexOfNext];
    [self setActiveNode:newNext];
    return newNext;
}

- (void) rewindToFirstNode{
    [self setActiveNode:[self nodes][0]];
}

@end
