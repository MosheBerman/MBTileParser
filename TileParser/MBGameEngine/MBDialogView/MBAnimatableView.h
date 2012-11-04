//
//  MBAnimatableView.h
//  TileParser
//
//  Created by Moshe Berman on 11/1/12.
//
//

#import <UIKit/UIKit.h>

//
//  Define some types for our parameters
//

typedef NSUInteger MBAnimatableViewPosition;
typedef NSUInteger MBAnimatableViewAnimation;
typedef NSUInteger MBAnimatableViewFormFactor;

//
//  Used for positioning dialog
//  and menu views.
//

enum MBAnimatableViewPosition {
    MBPositionTop = 0,
    MBPositionMiddle = 1,
    MBPositionBottom,
    MBPositionLeft,
    MBPositionRight,
};

//
//  Sets if the dialog is a tall or wide dialog.
//  (Or which is longer, the horizontal or vertical
//  side.)
//

enum MBFormFactor {
    MBFormFactorWide = 0,
    MBFormFactorNarrowTall = 1,
    MBFormFactorNarrowShort
};

//
//  Used to hide/show animatable and menu views.
//

enum MBAnimatableViewAnimation{
    MBAnimatableViewAnimationNone = 0,
    MBAnimatableViewAnimationSlideDown = 1,
    MBAnimatableViewAnimationSlideUp,
    MBAnimatableViewAnimationSlideLeft,
    MBAnimatableViewAnimationSlideRight,
    MBAnimatableViewAnimationPop,
    MBAnimatableViewAnimationFade,
};



@interface MBAnimatableView : UIView{
    CGFloat _maxWidth;
    CGFloat _maxHeight;
    CGFloat _horizontalMarginWidth;
    CGFloat _verticalMarginHeight;
}

@property (nonatomic, strong) UIView *contentView;

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

- (void) showInView:(UIView *)view withAnimation:(MBAnimatableViewAnimation)animation;

//
//  Calls the designated presentation method with
//  an animation type of MBDialogViewAnimationNone.
//

- (void) showInView:(UIView *)view atVerticalPosition:(MBAnimatableViewPosition)verticalPosition andHorizontalPosition:(MBAnimatableViewPosition)horizontalPosition;

//
//  The "designated" presentation method.
//  All showInView: related calls ultimately call this method.
//  It calculates the correct dimensions for the dialog view,
//  styles it up, and shows it.
//

- (void) showInView:(UIView *)view atVerticalPosition:(MBAnimatableViewPosition)verticalPosition andHorizontalPosition:(MBAnimatableViewPosition)horizontalPosition withAnimation:(MBAnimatableViewAnimation)animation;

//
//  Hides the view, using the animationType with
//  which it was originally displayed.
//

- (void) hide;

//
//  This method builds the contentView's
//  hierarchy at the appropriate times.
//
//  Do not call render manually.
//
//

- (void) render;


@end
