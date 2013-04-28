//
//  MBDialogView.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "MBDialogView.h"

#import "NSString+MBDialogString.h"

#import "UIApplication+MBDialog.h"

@interface MBDialogView ()

@property (nonatomic, strong) MBDialogTree *dialogTree;

//
//  Keep our own text cache, independent of the
//  MBDialogTree data structure, so that we can
//  break up the text to fit, as necessary.
//

@property (nonatomic, strong) NSArray * cacheOfCurrentNode;
@property (nonatomic) NSUInteger cacheIndex;

- (BOOL)hasNextInCache;
- (NSString *)nextStringFromCache;

//
//  The label displays text, naturally.
//

@property (nonatomic, strong) UILabel *label;

//
//  What kind of animation did we present with?
//

@property (nonatomic) MBDialogAnimation animationType;

@end

@implementation MBDialogView

- (id) init{
    self = [super init];
    
    if (self) {
        _maxWidth = 460;
        _maxHeight = 100;
        _horizontalMarginWidth = 20;
        _verticalMarginHeight = 5;
        _font = [UIFont systemFontOfSize:16];
        _formFactor = MBDialogFormFactorWide;
    }
    
    return self;
}

- (id) initWithDialogTree:(MBDialogTree *)dialogTree{
    
    self = [self init];
    
    if (self) {
        _dialogTree = dialogTree;
    }
    
    return self;
}

#pragma mark - Show MBDialogView in a UIView

//
//  Shows the dialog in the top level view
//  of the keyWindow.
//

- (void) show{
    
    UIView *rootView = [UIApplication rootView];
    
    [self showInView:rootView withAnimation:MBDialogViewAnimationPop];
}

//
//  Calls showInView:withAnimation: passing
//  in a value of MBDialogViewAnimationNone.
//

- (void) showInView:(UIView *)view{
    [self showInView:view withAnimation:MBDialogViewAnimationNone];
}

//
//  Calls showInView:atVerticalPosition:andHorizontalPosition:
//  passing in MBPositionTop and MBPositionMiddle respectively.
//  The animation value is passed through, naturally.
//

- (void) showInView:(UIView *)view withAnimation:(MBDialogAnimation)animation{
    [self showInView:view atVerticalPosition:MBPositionTop andHorizontalPosition:MBPositionMiddle withAnimation:animation];
}

//
//  Calls the designated presentation method with
//  an animation type of MBDialogViewAnimationNone.
//

- (void) showInView:(UIView *)view atVerticalPosition:(MBDialogPosition)verticalPosition andHorizontalPosition:(MBDialogPosition)horizontalPosition{
    [self showInView:view atVerticalPosition:verticalPosition andHorizontalPosition:horizontalPosition withAnimation:MBDialogViewAnimationNone];
}

//
//  The "designated" presentation method.
//  All showInView: related calls ultimately call this method.
//
//

- (void) showInView:(UIView *)view atVerticalPosition:(MBDialogPosition)verticalPosition andHorizontalPosition:(MBDialogPosition)horizontalPosition withAnimation:(MBDialogAnimation)animation{
    
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
    
    CGRect parentBounds = [view bounds];
    
    CGRect bounds = parentBounds;
    
    if ([self formFactor] == MBDialogFormFactorWide) {
        bounds.size.width = MIN(parentBounds.size.width - (_horizontalMarginWidth/2), [self maxWidth]);
        bounds.size.height = MIN(parentBounds.size.height/3.5-(_verticalMarginHeight/2), [self maxHeight]);
    }
    else if([self formFactor] ==  MBDialogFormFactorNarrowShort){
        bounds.size.width = MIN(parentBounds.size.width/3.5 - (_horizontalMarginWidth/2), [self maxWidth]);
        bounds.size.height = MIN(parentBounds.size.height/2-(_verticalMarginHeight/2), [self maxHeight]);
    }
    else if([self formFactor] == MBDialogFormFactorNarrowTall){
        bounds.size.width = MIN(parentBounds.size.width/3.5 - (_horizontalMarginWidth/2), [self maxWidth]);
        bounds.size.height = MIN(parentBounds.size.height-(_verticalMarginHeight/2), [self maxHeight]);
    }
    
    //
    //  Calculate a position, depending on the value of position
    //
    
    CGFloat top = 0;
    CGFloat left = 0;
    
    if (verticalPosition == MBPositionTop) {
        top = [self verticalMarginHeight];
    }else if(verticalPosition == MBPositionMiddle){
        top = parentBounds.size.height/2 - bounds.size.height/2;
    }else if(verticalPosition == MBPositionBottom){
        top = parentBounds.size.height - bounds.size.height - [self verticalMarginHeight];
    }
    
    if (horizontalPosition == MBPositionLeft) {
        left = [self horizontalMarginWidth];
    }else if(horizontalPosition == MBPositionMiddle){
        left = parentBounds.size.width/2 - bounds.size.width/2;
    }else if(horizontalPosition == MBPositionRight){
        left = parentBounds.size.width - bounds.size.width - [self horizontalMarginWidth];
    }
    
    //
    //  Position onscreen...
    //
    
    bounds.origin.x = left;
    bounds.origin.y = top;
    
    [self setFrame:bounds];
    
    //
    //  Animation Support before addSubview...
    //
    
    if(animation == MBDialogViewAnimationSlideDown){
        
        CGAffineTransform t = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -[view frame].size.height);
        [self setTransform:t];
    }
    else if(animation == MBDialogViewAnimationSlideUp){
        
        CGAffineTransform t = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, [view frame].size.height);
        [self setTransform:t];
        
    }
    else if(animation == MBDialogViewAnimationSlideLeft){
        
        CGAffineTransform t = CGAffineTransformTranslate(CGAffineTransformIdentity, -[view frame].size.width, 0);
        [self setTransform:t];
    }
    else if(animation == MBDialogViewAnimationSlideRight){
        
        CGAffineTransform t = CGAffineTransformTranslate(CGAffineTransformIdentity, [view frame].size.width, 0);
        [self setTransform:t];
    }
    else if (animation == MBDialogViewAnimationFade) {
        [self setAlpha:0];
    }
    else if (animation == MBDialogViewAnimationPop){
        [self setAlpha:0];
    }
    
    //
    //  Add subview
    //
    
    [self setClipsToBounds:YES];
    [self render];
    [view addSubview:self];
    
    //
    //  Animation support for after addSubview
    //
    
    if(animation >= MBDialogViewAnimationSlideDown && animation <= MBDialogViewAnimationSlideRight){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setTransform:CGAffineTransformIdentity];
        }];
    }
    else if (animation == MBDialogViewAnimationFade) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setAlpha:1];
            [[self label] setAlpha:1];
        }];
    }
    else if (animation == MBDialogViewAnimationPop){
        
        //
        //  Shrink to hide
        //
        
        CGAffineTransform t = CGAffineTransformScale([self transform], 0.1, 0.1);
        [self setTransform:t];
        
        /*
         
         Action      Scale   Duration
         
         Grow        1.05    0.2
         Shrink      0.9     1/15.0
         Grow        1.0     1/7.5
         
         */
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
            [self setTransform:t];
            
            [self setAlpha:0.8];
            
        }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:1/15.0 animations:^{
                                 
                                 CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                                 [self setTransform:t];
                                 
                                 [self setAlpha:0.8];
                             }
                                              completion:^(BOOL finished) {
                                                  [UIView animateWithDuration:1/7.5 animations:^{
                                                      
                                                      CGAffineTransform t = CGAffineTransformIdentity;
                                                      [self setTransform:t];
                                                      
                                                      [self setAlpha:1.0];
                                                  }];
                                                  
                                              }];
                         }];
    }
}

#pragma mark - Hide MBDialogView

//
//  Hides the dialog view with the animation
//  type initially used to show it.
//

- (void) hide{
    [self hideWithAnimation:[self animationType]];
}

//
//  Hides the view with a given animation
//

- (void) hideWithAnimation:(MBDialogAnimation)animation{
    
    //
    //  Prepare a transform for the slide animations
    //
    
    CGAffineTransform t;
    
    if(animation == MBDialogViewAnimationSlideDown){
        t = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -[self frame].size.height);
    }
    else if(animation == MBDialogViewAnimationSlideUp){
        t = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, [[self superview] frame].size.height);
    }
    else if(animation == MBDialogViewAnimationSlideLeft){
        t = CGAffineTransformTranslate(CGAffineTransformIdentity, -[self frame].size.width, 0);
    }
    else if(animation == MBDialogViewAnimationSlideRight){
        t = CGAffineTransformTranslate(CGAffineTransformIdentity, [self frame].size.width, 0);
    }
    
    //
    //  Apply the sliding transition animations
    //
    
    if(animation >= MBDialogViewAnimationSlideDown && animation <= MBDialogViewAnimationSlideRight){
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self setTransform:t];
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             [[self label] setText:nil];
                         }];
    }
    
    //
    //  Apply the non-animated transition
    //
    
    else if (animation == MBDialogViewAnimationNone) {
        [self removeFromSuperview];
    }
    
    //
    //  Apply the fadeout transition animation
    //
    
    else if(animation == MBDialogViewAnimationFade){
        [UIView animateWithDuration:0.3 animations:^{
            [self setAlpha:0];
        }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
    
    //
    //  Apply the pop - everyone's favorite
    //
    
    else if(animation == MBDialogViewAnimationPop){
        
        /*
         
         Action      Scale   Duration
         
         Shrink      0.9     0.2
         Shrink      1.05    0.9/15.0
         Grow        0.0     1/7.5
         
         */
        
        
        [UIView animateWithDuration:1/15.0 animations:^{
            
            CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
            [self setTransform:t];
            
            [self setAlpha:0.8];
            
        }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:1/7.5 animations:^{
                                 
                                 CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
                                 [self setTransform:t];
                                 
                                 [self setAlpha:0.6];
                                 
                                 [UIView animateWithDuration:.2 animations:^{
                                     CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
                                     [self setTransform:t];
                                     [self setAlpha:0];
                                 }
                                                  completion:^(BOOL finished) {
                                                      [self removeFromSuperview];
                                                  }];
                             }];
                             
                             
                         }];
    }
}
/* else if(animation == MBDialogViewAnimationPop){
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
 
 [[self label] setAlpha:0];
 
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
 [[self label] setText:nil];
 }];
 }];
 }];
 }    */


#pragma mark - Text loading and caching

//
//  Cache the text and show the first part of it.
//
//  Dialog caching only works in the base class.
//  Subclasses of the dialog class do not
//  support caching.
//

- (void) prepareCache{
    
    if (![self isMemberOfClass:[MBDialogView class]]) {
        return;
    }
    
    //
    //  Prepare our text...
    //
    
    [self cacheText];
    
    //
    //  Show the first substring that fits
    //
    
    [self cycleText];
    
}

//
//  Take the dialog tree, grab the current node,
//  then break it up so that we can see the entire
//  message, one part at a time, without it being
//  truncated by the UILabel.
//


- (void) cacheText{
    MBDialogTreeNode *node = [[self dialogTree] activeNode];
    
    if ([node hasNext]) {
        NSString *textToCache = [node nextStringToDisplay];
        
        //  Only cache if we actually want to cache stuff.
        if(textToCache != nil){
            NSArray *newDialog = [textToCache dialogArrayForFrame:[self labelFrame] andFont:[self font]];
            [self setCacheOfCurrentNode:newDialog];
        }
        
        [self setCacheIndex:0];
    }else {
        [self setCacheOfCurrentNode:nil];
    }
}

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


- (void) cycleText{
    
    if ([self hasNextInCache]) {
        NSString *textToRender = [self nextStringFromCache];
        [self renderText:textToRender];
    }
    else {
        
        //
        //  Store the end action
        //
        
        SEL endAction = [[[self dialogTree] activeNode] endAction];
        
        //
        //  Hide the dialog tree
        //
        
        [self hideWithAnimation:[self animationType]];
        
        //
        //  Rewind and proceed to the next node.
        //
        
        [[[self dialogTree] activeNode] rewind];
        
        //
        //  Perform the end action if there is one.
        //
        
        if(endAction){
            
            [[UIApplication sharedApplication] sendAction:endAction to:nil from:self forEvent:nil];
            
        }
    }
    
}

#pragma mark - Rendering and Layout

//
//  Renders the dialog view.
//  In this class, we pull out some text to
//  render and pass it to the renderText: method.
//  In other classes, such as the menu, we may
//  want to render several labels instead.
//

- (void) render{
    
    if (![self hasNextInCache]) {
        [self cacheText];
    }
    
    [self cycleText];
    
}

//
//  Takes a given string and sticks it into a UILabel onscreen.
//

- (void) renderText:(NSString *)text{
    
    //
    //  Prepare our label...
    //
    
    CGRect frame = [self labelFrame];
    
    if(![self label]){
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        [label setCenter:[self center]];
        [label setFont:[self font]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByClipping];
        [self setLabel:label];
    }
    
    [[self label] setFrame:frame];
    [[self label] setBounds:frame];
    
    [self addSubview:[self label]];
    
    [[self label] setText:text];
}


//
//  Calculates a frame for the dialog's
//  content area based on the frame of
//  the dialog view.
//

- (CGRect) labelFrame{
    CGRect frame = [self bounds];
    return [self labelFrameFromWrapperFrame:frame];
}

//
//  Calculates a frame for the UILabel
//  based on a given frame.
//

- (CGRect) labelFrameFromWrapperFrame:(CGRect) frame{
    frame.origin.y +=  [self verticalMarginHeight];
    frame.origin.x += [self horizontalMarginWidth];
    
    frame.size.height -= [self verticalMarginHeight]*2;
    frame.size.width -= [self horizontalMarginWidth]*2;
    
    return frame;
}

#pragma mark - Cycle Current Node

//
//  Check if our temporary dialog tree has more text,
//  if not we check the actual dialog tree.
//

- (BOOL)hasNextInCache{
    return [self cacheIndex] < [[self cacheOfCurrentNode] count];
}

//
//  Load the next string out of the cache
//

- (NSString *)nextStringFromCache{
    NSUInteger index = [self cacheIndex];
    NSString *string = [self cacheOfCurrentNode][index];
    if ([self hasNextInCache]) {
        index++;
        [self setCacheIndex:index];
    }
    return string;
}


//
//  Determines if the dialog view is visible in the root view of the keyWindow.
//

- (BOOL) isShowing{
    return [self isShowingInView:[UIApplication rootView]];
}

//
//  Determines if the dialog view is visible in a given view.
//

- (BOOL) isShowingInView:(UIView *)view{
    return [[view subviews] containsObject:self];
}


@end
