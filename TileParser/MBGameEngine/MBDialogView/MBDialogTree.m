//
//  MBDialogTree.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "MBDialogTree.h"

@implementation MBDialogTree

- (id)initWithNodes:(NSArray *)array
{
 
    self = [super init];
    
    if (self) {
        _nodes = array;
        _firstNode = array[0];
        _activeNode = _firstNode;
    }
    
    return self;
}

- (id)initWithMessage:(NSString *)dialogText
{
    
    MBDialogTreeNode *node = [[MBDialogTreeNode alloc] init];
    [node setDialog:@[dialogText]];
    return [self initWithNodes:@[node]];
}

- (id) initWithContentsOfFile:(NSString *)path
{
    NSArray *dialogNodes = [NSArray arrayWithContentsOfFile:path];
    return [self initWithNodes:dialogNodes];
}

- (id) initWithContentsOfURL:(NSURL *)url{
    NSArray *dialogNodes = [NSArray arrayWithContentsOfURL:url];
    
    //  TODO: Process the nodes.
    
    return [self initWithNodes:dialogNodes];
}

+ (MBDialogTree *)dialogTreeWithDictionary:(NSDictionary *)dictionary
{
    for (NSDictionary *treeNodeData in dictionary[@"nodes"]) {
//        MBDialogTreeNode *node = [MBDialogTreeNode nodeWithDictionary:dictionary];
    }
    
    MBDialogTree *tree = [MBDialogTree new];
    
    // TODO: Load dialog
    
    return tree;
}

#pragma mark -

- (NSUInteger)currentNode{
    return [[self nodes] indexOfObject:[self activeNode]];
}

- (BOOL)hasNext{
    if (![self activeNode] || ![[self nodes] count]) {
        return NO;
    }
    return [self currentNode] < [[self nodes] count]-1;
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

- (BOOL)rewindAndProceedToNextNode{
    if (![self hasNext]) {
        [self rewindToFirstNode];
        return NO;
    }
    
    [[self activeNode] rewind];
    [self setActiveNode:[self nextNode]];
    
    return YES;
}

- (void)rewindToFirstNode{
    [self setActiveNode:[self firstNode]];
    
    for (MBDialogTreeNode *node in [self nodes]) {
        [node rewind];
    }
}

@end
