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
typedef NSUInteger MBDialogFormFactor;

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

enum MBDialogFormFactor {
    MBDialogFormFactorWide = 0,
    MBDialogFormFactorNarrowTall = 1,
    MBDialogFormFactorNarrowShort
    };

@interface MBDialogView : UIView

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat horizontalMarginWidth;
@property (nonatomic, assign) CGFloat verticalMarginHeight;
@property (nonatomic, assign) MBDialogFormFactor formFactor;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIView *contentView;

- (id) initWithDialogTree:(MBDialogTree *)dialogTree;

//
//  Shows the dialog in the top level view
//  of the keyWindow.
//

- (void) show;

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
//  Hides the dialog view with the animation
//  type initially used to show it.
//

- (void) hide;

//
//  Hides the dialog view with a given animation.
//

- (void) hideWithAnimation:(MBDialogAnimation)animation;

//
//  Cycles through the current dialog item's text.
//  If it hits the end of the dialog, then either
//  queue up the next one, display a menu, or perform
//  some selector via the UIApplication method
//  sendAction:to:from:forEvent:
//

- (void) cycleText;

//
//  Calculates a frame for the dialog's content
//  area based on the frame of the dialog view.
//

- (CGRect) labelFrame;

//
//  Renders the dialog view.
//  In this class, we pull out some text to
//  render and pass it to the renderText: method.
//  In other classes, such as the menu, we may
//  want to render several labels instead.
//

- (void) render;

//
//  Determines if the dialog view is visible in the root view of the keyWindow.
//

- (BOOL) isShowing;

//
//  Determines if the dialog view is visible in a given view.
//

- (BOOL) isShowingInView:(UIView *)view;

@end
