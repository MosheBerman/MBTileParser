//
//  MBDialogView.h
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import <UIKit/UIKit.h>

#import "MBDialogTree.h"

typedef NSUInteger MBDialogPosition;

enum MBDialogViewPosition {
    MBPositionTop = 0,
    MBPositionMiddle = 1,
    MBPositionBottom,
    MBPositionLeft,
    MBPositionRight,
    };

@interface MBDialogView : UIView

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat horizontalMarginWidth;
@property (nonatomic, assign) CGFloat verticalMarginHeight;

@property (nonatomic, strong) UIFont *font;

- (id) initWithText:(NSString *)text;
- (id) initWithDialogTree:(MBDialogTree *)dialogTree;

//  Calls showInView:atPosition: and passes in MBPositionTop
- (void) showInView:(UIView *)view;
- (void) showInView:(UIView *)view atVerticalPosition:(MBDialogPosition)verticalPosition andHorizontalPosition:(MBDialogPosition)horizontalPosition;

- (void) cycleText;

@end
