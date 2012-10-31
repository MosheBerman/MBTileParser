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

@interface MBDialogView : UIView

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat horizontalMarginWidth;
@property (nonatomic, assign) CGFloat verticalMarginHeight;

@property (nonatomic, strong) UIFont *font;

- (id) initWithText:(NSString *)text;
- (id) initWithArrayOfText:(NSArray *)text;
- (id) initWithDialogTree:(MBDialogTree *)dialogTree;


//  Calls showInView:atPosition: and passes in MBPositionTop
- (void) showInView:(UIView *)view;
- (void) showInView:(UIView *)view withAnimation:(MBDialogAnimation)animation;
- (void) showInView:(UIView *)view atVerticalPosition:(MBDialogPosition)verticalPosition andHorizontalPosition:(MBDialogPosition)horizontalPosition;
- (void) showInView:(UIView *)view atVerticalPosition:(MBDialogPosition)verticalPosition andHorizontalPosition:(MBDialogPosition)horizontalPosition withAnimation:(MBDialogAnimation)animation;

- (void) cycleText;

@end
