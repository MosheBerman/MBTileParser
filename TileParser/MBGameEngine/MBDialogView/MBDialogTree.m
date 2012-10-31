//
//  MBDialogTree.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "MBDialogTree.h"

@implementation MBDialogTree

- (id) initWithContentsOfArrayOfNodes:(NSArray *)array{
 
    self = [super init];
    
    if (self) {
        _nodes = array;
        _firstNode = array[0];
        _activeNode = _firstNode;
    }
    
    return self;
}

- (id) initWithContentsOfArrayOfStrings:(NSArray *)array{
    
    MBDialogTreeNode *node = [[MBDialogTreeNode alloc] init];
        
    [node setDialog:array];
        
    return [self initWithContentsOfArrayOfNodes:@[node]];
}

- (id) initWithMessage:(NSString *)dialogText{
    
    MBDialogTreeNode *node = [[MBDialogTreeNode alloc] init];
    [node setDialog:@[dialogText]];
    return [self initWithContentsOfArrayOfNodes:@[node]];
}

- (id) initWithContentsOfFile:(NSString *)path{
    NSArray *dialogNodes = [NSArray arrayWithContentsOfFile:path];
    return [self initWithContentsOfArrayOfNodes:dialogNodes];
}

- (id) initWithContentsOfURL:(NSURL *)url{
    NSArray *dialogNodes = [NSArray arrayWithContentsOfURL:url];
    
    //  TODO: Process the nodes.
    
    return [self initWithContentsOfArrayOfNodes:dialogNodes];
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

    NSUInteger indexOfNext = [self currentNode] +1;
    MBDialogTreeNode *newNext = [self nodes][indexOfNext];
    [self setActiveNode:newNext];
    return newNext;
}

//
//  Rewind the current node. Then, if we
//  have a nextNode, proceed to the next node
//  and return YES.
//
//  Returns NO and rewinds to the first node
//  if there's no next node.
//

- (BOOL) rewindAndProceedToNextNode{
    if (![self hasNext]) {
        [self rewindToFirstNode];
        return NO;
    }
    
    [[self activeNode] rewind];
    [self setActiveNode:[self nextNode]];
    
    return YES;
}

- (void) rewindToFirstNode{
    [self setActiveNode:[self firstNode]];
    
    for (MBDialogTreeNode *node in [self nodes]) {
        [node rewind];
    }
}

@end
