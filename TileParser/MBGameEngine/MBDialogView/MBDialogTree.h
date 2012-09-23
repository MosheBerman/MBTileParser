//
//  MBDialogTree.h
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import <Foundation/Foundation.h>

#import "MBDialogTreeNode.h"

@interface MBDialogTree : NSObject

@property (nonatomic, strong) NSArray *nodes;
@property (nonatomic, strong) MBDialogTreeNode *firstNode;
@property (nonatomic, strong) MBDialogTreeNode *activeNode;

//  Designated initializer
- (id) initWithContentsOfArray:(NSArray *)array;

//Convenience initializers
- (id) initWithMessage:(NSString *)dialogText;
- (id) initWithContentsOfFile:(NSString *)path;
- (id) initWithContentsOfURL:(NSURL *)url;

// Accessing nodes

- (BOOL) hasNext;
- (MBDialogTreeNode *)nextNode;

@end
