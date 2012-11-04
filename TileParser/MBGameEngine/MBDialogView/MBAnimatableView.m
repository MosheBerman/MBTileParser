//
//  MBAnimatableView.m
//  TileParser
//
//  Created by Moshe Berman on 11/1/12.
//
//

#import "MBAnimatableView.h"

#import "UIApplication+MBDialog.h"

@interface MBAnimatableView ()

@property (nonatomic, assign) CGRect targetFrame;

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat horizontalMarginWidth;
@property (nonatomic, assign) CGFloat verticalMarginHeight;

@property (nonatomic, assign) MBAnimatableViewAnimation animationType;
@property (nonatomic, assign) MBAnimatableViewFormFactor formFactor;


@end

@implementation MBAnimatableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _maxWidth = 460;
        _maxHeight = 100;
        _horizontalMarginWidth = 20;
        _verticalMarginHeight = 5;
        _targetFrame = frame;
        _formFactor = MBFormFactorNarrowTall;
    }
    
    return self;
}


#pragma mark - Show MBDialogView in a UIView

//
//  Calls showInView:withAnimation: passing
//  in a value of MBDialogViewAnimationNone.
//

- (void) showInView:(UIView *)view{
    [self showInView:view withAnimation:MBAnimatableViewAnimationNone];
}

//
//  Calls showInView:atVerticalPosition:andHorizontalPosition:
//  passing in MBPositionTop and MBPositionMiddle respectively.
//  The animation value is passed through, naturally.
//

- (void) showInView:(UIView *)view withAnimation:(MBAnimatableViewAnimation)animation{
    [self showInView:view atVerticalPosition:MBPositionTop andHorizontalPosition:MBPositionMiddle withAnimation:animation];
}

//
//  Calls the designated presentation method with
//  an animation type of MBDialogViewAnimationNone.
//

- (void) showInView:(UIView *)view atVerticalPosition:(MBAnimatableViewPosition)verticalPosition andHorizontalPosition:(MBAnimatableViewPosition)horizontalPosition{
    [self showInView:view atVerticalPosition:verticalPosition andHorizontalPosition:horizontalPosition withAnimation:MBAnimatableViewAnimationNone];
}

//
//  The "designated" presentation method.
//  All showInView: related calls ultimately call this method.
//
//

- (void) showInView:(UIView *)view atVerticalPosition:(MBAnimatableViewPosition)verticalPosition andHorizontalPosition:(MBAnimatableViewPosition)horizontalPosition withAnimation:(MBAnimatableViewAnimation)animation{
    
    //
    //  Remember the animation type for later
    //
    
    [self setAnimationType:animation];
    
    //
    //  Prep the view...
    //
    
    [[self layer] setCornerRadius:4.0];
    [[self layer] setBackgroundColor:[[UIColor colorWithWhite:1.0 alpha:0.9] CGColor]];
    [[self layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [[self layer] setBorderWidth:1];
    
    //
    //  Ensure the correct behavior occurs when rotating the device.
    //  To do so, pick out the correct autoresizing masks.
    //
    
    NSUInteger resizingMask = UIViewAutoresizingNone;
    
    //  Configure the vertical resizing mask
    
    if (verticalPosition == MBPositionMiddle) {
        resizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    else if(verticalPosition == MBPositionTop){
        resizingMask = UIViewAutoresizingFlexibleBottomMargin;
    }
    else if(verticalPosition == MBPositionBottom){
        resizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    //  Configure the horizontal resizing mask
    
    if (horizontalPosition == MBPositionMiddle) {
        resizingMask += UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    else if(horizontalPosition == MBPositionLeft){
        resizingMask += UIViewAutoresizingFlexibleRightMargin;
    }
    else if(horizontalPosition == MBPositionRight){
        resizingMask += UIViewAutoresizingFlexibleLeftMargin;
    }
    
    [self setAutoresizingMask:resizingMask];
    
    //
    //  Calculate the size we want
    //
    
    CGRect bounds = [view bounds];
    
    if ([self formFactor] == MBFormFactorWide) {
        bounds.size.width = MIN(bounds.size.width - (_horizontalMarginWidth/2), [self maxWidth]);
        bounds.size.height = MIN(bounds.size.height/3.5-(_verticalMarginHeight/2), [self maxHeight]);
    }
    else if([self formFactor] == MBFormFactorNarrowShort){
        bounds.size.width = MIN(bounds.size.width/3.5 - (_horizontalMarginWidth/2), [self maxWidth]);
        bounds.size.height = MIN(bounds.size.height/2-(_verticalMarginHeight/2), [self maxHeight]);
    }
    else if([self formFactor] == MBFormFactorNarrowTall){
        bounds.size.width = MIN(bounds.size.width/3.5 - (_horizontalMarginWidth/2), [self maxWidth]);
        bounds.size.height = MIN(bounds.size.height-(_verticalMarginHeight/2), [self maxHeight]);
    }
    
    //
    //  Calculate a position, depending on the value of position
    //
    
    CGFloat top = 0;
    CGFloat left = 0;
    
    if (verticalPosition == MBPositionTop) {
        top = [self verticalMarginHeight];
    }else if(verticalPosition == MBPositionMiddle){
        top = bounds.size.height/2 - bounds.size.height/2;
    }else if(verticalPosition == MBPositionBottom){
        top = bounds.size.height - bounds.size.height - [self verticalMarginHeight];
    }
    
    if (horizontalPosition == MBPositionLeft) {
        left = [self horizontalMarginWidth];
    }else if(horizontalPosition == MBPositionMiddle){
        left = bounds.size.width/2 - bounds.size.width/2;
    }else if(horizontalPosition == MBPositionRight){
        left = bounds.size.width - bounds.size.width - [self horizontalMarginWidth];
    }
    
    //
    //  Position onscreen...
    //
    
    bounds.origin.x = left;
    bounds.origin.y = top;
    
    [self setBounds:bounds];
    [self setFrame:bounds];
    
    //
    //  Animation Support before addSubview...
    //
    
    CGRect startingBounds = bounds;
    
    if(animation == MBAnimatableViewAnimationSlideDown){
        
        startingBounds.origin.y -= startingBounds.size.height;
        startingBounds.origin.x = bounds.origin.x;
        
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
        [[self contentView] setCenter:[self center]];
        [[self contentView] setBounds:startingBounds];
    }
    else if(animation == MBAnimatableViewAnimationSlideUp){
        
        startingBounds.origin.y = view.frame.size.height;
        startingBounds.origin.x = bounds.origin.x;
        
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
        [[self contentView] setCenter:[self center]];
        [[self contentView] setBounds:startingBounds];
    }
    else if(animation == MBAnimatableViewAnimationSlideLeft){
        
        startingBounds.origin.x = -view.frame.size.width;
        startingBounds.origin.y = bounds.origin.y;
        
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
        [[self contentView] setCenter:[self center]];
        [[self contentView] setBounds:startingBounds];
    }
    else if(animation == MBAnimatableViewAnimationSlideRight){
        
        startingBounds.origin.x = view.frame.size.width;
        startingBounds.origin.y = bounds.origin.y;
        
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
        [[self contentView] setCenter:[self center]];
        [[self contentView] setBounds:startingBounds];
    }
    else if (animation == MBAnimatableViewAnimationFade) {
        [self setAlpha:0];
    }
    else if (animation == MBAnimatableViewAnimationPop){
        startingBounds.size.width = 0;
        startingBounds.size.height = 0;
        startingBounds.origin.x = bounds.size.width/2;
        startingBounds.origin.y = bounds.size.height/2;
        [self setAlpha:0];
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
    }
    
    //
    //  Add subview
    //
    
    [self setClipsToBounds:YES];
    if(animation != MBAnimatableViewAnimationPop){
        [self render];
    }
    
    [self addSubview:[self contentView]];
    [view addSubview:self];
    
    //
    //  Animation support for after addSubview
    //
    
    if(animation >= MBAnimatableViewAnimationSlideDown && animation <= MBAnimatableViewAnimationSlideRight){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setBounds:bounds];
            [self setFrame:bounds];
            
            //
            //  We need to keep the label centered
            //  throughout the animation.
            //
            
            [[self contentView] setCenter:[self center]];
            [[self contentView] setBounds:bounds];
        }];
    }
    else if (animation == MBAnimatableViewAnimationFade) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setAlpha:1];
            [[self contentView] setAlpha:1];
        }];
    }
    else if (animation == MBAnimatableViewAnimationPop){
        
        [self setAlpha:0.6];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect intermediateBounds = bounds;
            
            intermediateBounds.size.width *= 1.05;
            intermediateBounds.size.height *= 1.05;
            
            [self setBounds:intermediateBounds];
            [self setFrame:intermediateBounds];
            [[self contentView] setBounds:intermediateBounds];
            [self setAlpha:0.8];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1/15.0 animations:^{
                CGRect intermediateBounds = bounds;
                
                intermediateBounds.size.width *= 0.9;
                intermediateBounds.size.height *= 0.9;
                
                [self setBounds:intermediateBounds];
                [self setFrame:intermediateBounds];
                [[self contentView] setBounds:intermediateBounds];
                [self setAlpha:0.9];
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1/7.5 animations:^{
                    [self setBounds:bounds];
                    [self setFrame:bounds];
                    [[self contentView] setBounds:bounds];
                    [self setAlpha:1.0];
                    
                    [UIView animateWithDuration:1/7.5 animations:^{
                        [self render];
                    }];
                }];
            }];
        }];
    }
}

#pragma mark - Hide the MBDialogView

- (void) hide{
    [self hideWithAnimation:[self animationType]];
}

- (void) hideWithAnimation:(MBAnimatableViewAnimation)animation{
    
    CGRect startingBounds = [self bounds];
    UIView *view = [self superview];
    
    if(animation == MBAnimatableViewAnimationSlideDown){
        startingBounds.origin.y -= startingBounds.size.height;
    }
    else if(animation == MBAnimatableViewAnimationSlideUp){
        
        startingBounds.origin.y = view.frame.size.height;
    }
    else if(animation == MBAnimatableViewAnimationSlideLeft){
        startingBounds.origin.x = -self.frame.size.width;
    }
    else if(animation == MBAnimatableViewAnimationSlideRight){
        
        startingBounds.origin.x = self.frame.size.width;
    }
    else if (animation == MBAnimatableViewAnimationPop){
        startingBounds.origin.x = startingBounds.size.width/2;
        startingBounds.origin.y = startingBounds.size.height/2;
        startingBounds.size.width = 0;
        startingBounds.size.height = 0;
        [self setAlpha:0];
    }
    
    if (animation == MBAnimatableViewAnimationNone) {
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
        [[self contentView] removeFromSuperview];
        [self removeFromSuperview];
    }
    else if(animation == MBAnimatableViewAnimationFade){
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self setAlpha:0];
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                            [[self contentView] removeFromSuperview];
                         }];
    }
    else if(animation == MBAnimatableViewAnimationPop){
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect intermediateBounds = startingBounds;
            
            intermediateBounds.size.width *= 0.9;
            intermediateBounds.size.height *= 0.9;
            
            [self setBounds:intermediateBounds];
            [self setFrame:intermediateBounds];
            [self setAlpha:0.9];
            
            //
            //  Hide the label at this point
            //  so it doesn't look funny as
            //  we pop the dialog away
            //
            
        [[self contentView] setAlpha:0];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1/15.0 animations:^{
                CGRect intermediateBounds = startingBounds;
                
                intermediateBounds.size.width *= 1.05;
                intermediateBounds.size.height *= 1.05;
                
                [self setBounds:intermediateBounds];
                [self setFrame:intermediateBounds];
                [self setAlpha:0.8];
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:1/15.0 animations:^{
                    CGRect intermediateBounds = startingBounds;
                    
                    intermediateBounds.size.width = 0;
                    intermediateBounds.size.height = 0;
                    
                    [self setBounds:intermediateBounds];
                    [self setFrame:intermediateBounds];
                    
                    [self setAlpha:0];
                    
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                    [[self contentView] removeFromSuperview];
                }];
            }];
        }];
    }
    else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self setBounds:startingBounds];
                             [self setFrame:startingBounds];
                             [[self contentView] setCenter:[self center]];
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             [[self contentView] removeFromSuperview];
                         }];
    }
    
}

#pragma mark - Render the MBAnimatableView

- (void) render{
    [[self contentView] setAlpha:1];
    [self addSubview:[self contentView]];
    [[UIApplication rootView] addSubview:self];
}

@end
