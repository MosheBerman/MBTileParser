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
typedef NSUInteger MBDialogAnimation;
typedef NSUInteger MBDialogDimensions;

//
//  Used for positioning dialog
//  and menu views.
//

enum MBDialogViewPosition {
    MBPositionTop = 0,
    MBPositionMiddle = 1,
    MBPositionBottom,
    MBPositionLeft,
    MBPositionRight,
    };

//
//  Used to hide/show dialog and
//  menu views.
//

enum MBDialogViewAnimation {
    MBDialogViewAnimationNone = 0,
    MBDialogViewAnimationSlideDown = 1,
    MBDialogViewAnimationSlideUp,
    MBDialogViewAnimationSlideLeft,
    MBDialogViewAnimationSlideRight,
    MBDialogViewAnimationPop,
    MBDialogViewAnimationFade,
    };

//
//  Sets if the dialog is a tall or wide dialog.
//  (Or which is longer, the horizontal or vertical
//  side.)
//

enum MBDialogDimensions {
    MBDialogDimensionsWide = 0,
    MBDialogDimensionsNarrowTall = 1,
    MBDialogDimensionsNarrowShort
    };

@interface MBDialogView : UIView

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat horizontalMarginWidth;
@property (nonatomic, assign) CGFloat verticalMarginHeight;
@property (nonatomic, assign) MBDialogDimensions dimensionStyle;

@property (nonatomic, strong) UIFont *font;


- (id) initWithText:(NSString *)text;
- (id) initWithArrayOfText:(NSArray *)text;
- (id) initWithDialogTree:(MBDialogTree *)dialogTree;


//
//  Calls showInView:withAnimation: passing
//  in a value of MBDialogViewAnimationNone.
//

- (void) showInView:(UIView *)view;

//
//  Calls showInView:atVerticalPosition:andHorizontalPosition:
//  passing in MBPositionTop and MBPositionMiddle respectively.
//  The animation value is passed through, naturally.
//

- (void) showInView:(UIView *)view withAnimation:(MBDialogAnimation)animation;

//
//  Calls the designated presentation method with
//  an animation type of MBDialogViewAnimationNone.
//

- (void) showInView:(UIView *)view atVerticalPosition:(MBDialogPosition)verticalPosition andHorizontalPosition:(MBDialogPosition)horizontalPosition;

//
//  The "designated" presentation method.
//  All showInView: related calls ultimately call this method.
//  It calculates the correct dimensions for the dialog view,
//  styles it up, and shows it.
//

- (void) showInView:(UIView *)view atVerticalPosition:(MBDialogPosition)verticalPosition andHorizontalPosition:(MBDialogPosition)horizontalPosition withAnimation:(MBDialogAnimation)animation;

//
//
//

- (void) cycleText;

@end
