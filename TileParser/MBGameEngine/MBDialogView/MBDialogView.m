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

- (id) initWithText:(NSString *)text{
    MBDialogTree *tree = [[MBDialogTree alloc] initWithMessage:text];
    return [self initWithDialogTree:tree];
}

- (id) initWithDialogTree:(MBDialogTree *)dialogTree{
    
    self = [self init];
    
    if (self) {
        _dialogTree = dialogTree;
    }
    
    return self;
}

- (void) showInView:(UIView *)view{
    [self showInView:view atVerticalPosition:MBPositionTop andHorizontalPosition:MBPositionMiddle];
    
}

- (void) showInView:(UIView *)view atVerticalPosition:(MBDialogPosition)verticalPosition andHorizontalPosition:(MBDialogPosition)horizontalPosition{
    
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
    
    [view addSubview:self];
    
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
    else{
        [self removeFromSuperview];
        [[self dialogTree] rewindToFirstNode];
        
        //  TODO: End action
        
        [self cacheText];
    }
}

//
//  Takes a given string and sticks it into a UILabel onscreen
//

- (void) renderText:(NSString *)text{
    
    //
    //  Remove any previous labels from the view hierarchy
    //
    
    for(id view in [self subviews]) {
        if([[view class] isSubclassOfClass:[UILabel class]]){
            [(UIView *)view removeFromSuperview];
        }
    }
    
    //
    //  Prepare our label...
    //
    
    UILabel *label = [[UILabel alloc] initWithFrame:[self labelFrame]];
    [label setCenter:[self center]];
    [label setFont:[self font]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByClipping];
    [self addSubview:label];
    
    [label setText:text];
}

#pragma mark - Frame

- (CGRect) labelFrame{
    
    CGRect frame = [self frame];
    
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
