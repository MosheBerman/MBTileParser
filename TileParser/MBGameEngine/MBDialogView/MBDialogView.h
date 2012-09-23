//
//  MBDialogView.h
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import <UIKit/UIKit.h>

#import "MBDialogTree.h"

@interface MBDialogView : UIView

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat horizontalMarginWidth;
@property (nonatomic, assign) CGFloat verticalMarginHeight;

- (id) initWithText:(NSString *)text;
- (id) initWithDialogTree:(MBDialogTree *)dialogTree;

- (void) showInView:(UIView *)view;
- (void) cycleText;

@end
