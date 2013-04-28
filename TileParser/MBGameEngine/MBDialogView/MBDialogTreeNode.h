//
//  MBDialogTree.h
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//
//  The MBDialogTreeNode is a data model class which holds
//  information for a screenful of dialog and associated objects.
//

#import <Foundation/Foundation.h>

@interface MBDialogTreeNode : NSObject

//
//  An array of NSStrings. The strings are displayed by the MBDialogView
//  class. Each string is broken up to fit in the MBDialogView. You can
//  force a break by seperating strings into different items in the array.
//

@property (nonatomic, strong) NSArray *dialog;

//
//  The display name for the node, used in menus
//

@property (nonatomic, strong) NSString *displayName;

//
//  The action to run after the dialog is all displayed, unless
//  there's no dialog. In that case the end action is ignored.
//
//  What if instead of endActions we had a notification string to dispatch?
//  Then any object that was registered can run the action.
//
//  Another option would be to turn this into a FIFO queue of blocks.
//  Mmm, blocks... Tasty...
//

@property (nonatomic, assign) SEL endAction;

//
//  Arbitrary data, such as quantites, or item prices.
//

@property (nonatomic, strong) NSDictionary *payload;

//
//  The responses to the dialog. Valid responses values include
//  other DialogTreeNode objects.
//

@property (nonatomic, strong) NSDictionary *responses;

//
//  Determines if there's another string to display.
//

- (BOOL) hasNext;

//
//  Returns the next portion of dialog to be displayed.
//

- (NSString *) nextStringToDisplay;

//
//  Resets the state of the node.
//

- (void) rewind;

@end
