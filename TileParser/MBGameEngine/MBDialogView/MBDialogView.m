//
//  MBDialogView.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "MBDialogView.h"

#import "NSString+MBDialogString.h"

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
@property (nonatomic) CGRect finalFrame;

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

- (id) initWithText:(NSString *)text{
    MBDialogTree *tree = [[MBDialogTree alloc] initWithMessage:text];
    return [self initWithDialogTree:tree];
}


- (id) initWithArrayOfText:(NSArray *)text{
    MBDialogTree *tree = [[MBDialogTree alloc] initWithContentsOfArrayOfStrings:text];
    return [self initWithDialogTree:tree];
}

#pragma mark - Show MBDialogView in a UIView

- (void) showInView:(UIView *)view{
    [self showInView:view atVerticalPosition:MBPositionTop andHorizontalPosition:MBPositionMiddle];
}

- (void) showInView:(UIView *)view withAnimation:(MBDialogAnimation)animation{
    [self showInView:view atVerticalPosition:MBPositionTop andHorizontalPosition:MBPositionMiddle withAnimation:animation];
}

- (void) showInView:(UIView *)view atVerticalPosition:(MBDialogPosition)verticalPosition andHorizontalPosition:(MBDialogPosition)horizontalPosition{
    [self showInView:view atVerticalPosition:verticalPosition andHorizontalPosition:horizontalPosition withAnimation:MBDialogViewAnimationNone];
}

- (void) showInView:(UIView *)view atVerticalPosition:(MBDialogPosition)verticalPosition andHorizontalPosition:(MBDialogPosition)horizontalPosition withAnimation:(MBDialogAnimation)animation{
    
    //
    //  Remember the animation type for later
    //
    
    [self setAnimationType:animation];
    
    //
    //  Prep the rectangle...
    //
    
    [[self layer] setCornerRadius:4.0];
    [[self layer] setBackgroundColor:[[UIColor colorWithWhite:1.0 alpha:0.65] CGColor]];
    [[self layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [[self layer] setBorderWidth:1];
    
    CGRect parentBounds = [view bounds];
    
    CGRect bounds = parentBounds;
    
    bounds.size.width = MIN(parentBounds.size.width - (_horizontalMarginWidth/2), [self maxWidth]);
    bounds.size.height = parentBounds.size.height/3.5;
    
    //
    //  Keep a reference to the final bounds so
    //  we can size the label before actually displaying
    //  the containing frame.
    //
    
    [self setFinalFrame:bounds];
    
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
    
    [self setBounds:bounds];
    [self setFrame:bounds];
    
    //
    //  Animation Support before addSubview...
    //
    
    CGRect startingBounds = bounds;
    
    if(animation == MBDialogViewAnimationSlideDown){
        
        startingBounds.origin.y -= startingBounds.size.height;
        startingBounds.origin.x = bounds.origin.x;
        
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
        [[self label] setCenter:[self center]];
        
    }
    else if(animation == MBDialogViewAnimationSlideUp){
        
        startingBounds.origin.y = view.frame.size.height;
        startingBounds.origin.x = bounds.origin.x;
        
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
        [[self label] setCenter:[self center]];
        
    }
    else if(animation == MBDialogViewAnimationSlideLeft){
        
        startingBounds.origin.x = -view.frame.size.width;
        startingBounds.origin.y = bounds.origin.y;
        
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
        [[self label] setCenter:[self center]];
    }
    else if(animation == MBDialogViewAnimationSlideRight){
        
        startingBounds.origin.x = startingBounds.size.width;
        startingBounds.origin.y = bounds.origin.y;
        
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
        [[self label] setCenter:[self center]];
    }
    else if (animation == MBDialogViewAnimationFade) {
        [self setAlpha:0];
    }
    else if (animation == MBDialogViewAnimationPop){
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
    if(animation != MBDialogViewAnimationPop){
        [self loadFirstText];
    }
    [view addSubview:self];
    
    //
    //  Animation support for after addSubview
    //
    
    if(animation >= MBDialogViewAnimationSlideDown && animation <= MBDialogViewAnimationSlideRight){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setBounds:bounds];
            [self setFrame:bounds];
            
            //
            //  We need to keep the label centered
            //  throughout the animation.
            //
            
            [[self label] setCenter:[self center]];
        }];
    }
    else if (animation == MBDialogViewAnimationFade) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setAlpha:1];
            [[self label] setAlpha:1];
        }];
    }
    else if (animation == MBDialogViewAnimationPop){

        [self setAlpha:0.6];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect intermediateBounds = bounds;
            
            intermediateBounds.size.width *= 1.05;
            intermediateBounds.size.height *= 1.05;
            
            [self setBounds:intermediateBounds];
            [self setFrame:intermediateBounds];
            
            [self setAlpha:0.8];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1/15.0 animations:^{
                CGRect intermediateBounds = bounds;
                
                intermediateBounds.size.width *= 0.9;
                intermediateBounds.size.height *= 0.9;
                
                [self setBounds:intermediateBounds];
                [self setFrame:intermediateBounds];
                [self setAlpha:0.9];
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1/7.5 animations:^{
                    
                    CGRect intermediateBounds = bounds;
                    
                    [self setBounds:intermediateBounds];
                    [self setFrame:intermediateBounds];
                    
                    [self setAlpha:1.0];

                    [UIView animateWithDuration:1/7.5 animations:^{
                        [self loadFirstText];
                        [[self label] setAlpha:1.0];
                    }];
                }];
            }];
        }];
    }
}

#pragma mark - Hide MBDialogView

- (void) hideWithAnimation:(MBDialogAnimation)animation{
    
    
    CGRect startingBounds = [self bounds];
    UIView *view = [self superview];
    
    if(animation == MBDialogViewAnimationSlideDown){
        startingBounds.origin.y -= startingBounds.size.height;
    }
    else if(animation == MBDialogViewAnimationSlideUp){
        
        startingBounds.origin.y = view.frame.size.height;
    }
    else if(animation == MBDialogViewAnimationSlideLeft){
        startingBounds.origin.x = -self.frame.size.width;
    }
    else if(animation == MBDialogViewAnimationSlideRight){
        
        startingBounds.origin.x = self.frame.size.width;
    }
    else if (animation == MBDialogViewAnimationPop){
        startingBounds.origin.x = startingBounds.size.width/2;
        startingBounds.origin.y = startingBounds.size.height/2;
        startingBounds.size.width = 0;
        startingBounds.size.height = 0;
        [self setAlpha:0];
    }
    
    if (animation == MBDialogViewAnimationNone) {
        [self setBounds:startingBounds];
        [self setFrame:startingBounds];
        [self removeFromSuperview];
        [[self label] setText:nil];
    }
    else if(animation == MBDialogViewAnimationFade){
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self setAlpha:0];
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             [[self label] setText:nil];
                         }];
    }
    else if(animation == MBDialogViewAnimationPop){
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
    }
    else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self setBounds:startingBounds];
                             [self setFrame:startingBounds];
                            [[self label] setCenter:[self center]];                             
                         }
        completion:^(BOOL finished) {
            [self removeFromSuperview];
            [[self label] setText:nil];
        }];
    }
    
}

#pragma mark - Text loading and caching

//
//  Cache the text and show the first part of it.
//

- (void) loadFirstText{
    
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
        
        NSArray *newDialog = [textToCache dialogArrayForFrame:[self labelFrame] andFont:[self font]];
        
        [self setCacheOfCurrentNode:newDialog];
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
        [self cacheText];
        if ([self cacheOfCurrentNode]) {
            [self cycleText];
        }
        else{
            [self hideWithAnimation:[self animationType]];
            [[self dialogTree] rewindToFirstNode];
            
            //  TODO: End action
        }
    }
}

//
//  Takes a given string and sticks it into a UILabel onscreen
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
    
    [self addSubview:[self label]];
    
    [[self label] setText:text];
}


//
//  Calculates a frame for the UILabel
//  based on the frame of the dialog view.
//

- (CGRect) labelFrame{
    CGRect frame = [self finalFrame];
    return [self labelFrameFromWrapperFrame:frame];
}

//
//  Calculates a frame for the UILabel
//  based on a given frame
//

- (CGRect) labelFrameFromWrapperFrame:(CGRect) frame{
    frame.origin.y +=  [self verticalMarginHeight];
    frame.origin.x += [self horizontalMarginWidth];
    
    frame.size.height -= [self verticalMarginHeight];
    frame.size.width -= [self horizontalMarginWidth];
    
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
    index++;
    [self setCacheIndex:index];
    return string;
}


@end
