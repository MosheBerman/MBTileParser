//
//  MBDialogView.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "MBDialogView.h"

@interface MBDialogView ()

@property (nonatomic, strong) MBDialogTree *dialogTree;

@end

@implementation MBDialogView

- (id) init{
    self = [super init];
    
    if (self) {
        _maxWidth = 300;
        _horizontalMarginWidth = 20;
        _verticalMarginHeight = 5;
    }
    
    return self;
}

- (id) initWithText:(NSString *)text{
    
    self  = [self init];
    
    if (self) {
        
        _dialogTree = [[MBDialogTree alloc] initWithMessage:@"A dialog tree appeared."];
        
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
    
    bounds.size.width = parentBounds.size.width - (_horizontalMarginWidth/2);
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
    }else if(verticalPosition == MBPositionMiddle){
        left = parentBounds.size.width/2 - bounds.size.width/2;
    }else if(verticalPosition == MBPositionRight){
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

    [self cycleText];
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
    
    MBDialogTreeNode *node = [[self dialogTree] activeNode];
    
    if ([node hasNext]) {
        NSString *textToRender = [node nextStringToDisplay];
        [self renderText:textToRender];
    }else{
        [self removeFromSuperview];
        [[self dialogTree] rewindToFirstNode];
    }
}

//
//  Takes a given string and sticks it into a UILabel onscreen
//

- (void) renderText:(NSString *)text{
    
    CGRect frame = [self frame];
    CGRect selfFrame = frame;
    
    frame.size.width -= _horizontalMarginWidth;
    frame.size.height -= _verticalMarginHeight;
    
    frame.origin.x = selfFrame.size.width/2 - frame.size.width/2;
    frame.origin.y = selfFrame.size.height/2 - frame.size.height/2;
    
    for(id view in [self subviews]) {
        if([[view class] isSubclassOfClass:[UILabel class]]){
            [(UIView *)view removeFromSuperview];
        }
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setNumberOfLines:0];
    [self addSubview:label];
    
    [label setText:text];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 
 NSLog(@"%@", NSStringFromCGRect(rect));
 }
 */
@end
