//
//  MBDialogViewController.h
//  TileParser
//
//  Created by Moshe Berman on 11/1/12.
//
//

#import <UIKit/UIKit.h>

#import "MBDialogView.h"

#import "MBDialogTree.h"

@interface MBDialogViewController : UIViewController

@property (nonatomic, strong) MBDialogView *dialogView;

@property (nonatomic, readonly, assign) BOOL isShowing;

- (id)initWithDialogTree:(MBDialogTree *)tree;

//
//  Presents the dialog view in the top of the
//  keyed window view hierarchy with an animation.
//
//

- (void) show;

//
//  First, check if we have a previous node. If so
//  see if there's more text to show. If there is,
//  show it.
//
//  If there is no new text, check for responses and
//  offer them.
//
//  If there's no responses, run the selector if it exists.
//
//  Pull out the node we want.
//

- (void) cycleText;

@end
