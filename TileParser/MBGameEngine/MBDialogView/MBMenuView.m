//
//  MBMenuView.m
//  TileParser
//
//  Created by Moshe Berman on 10/31/12.
//
//

#import "MBMenuView.h"

#import "MBDialogTreeNode.h"

@interface MBMenuView ()

//  The nodes to display
@property (nonatomic, strong) NSArray *nodes;

//  An index of the selected view
@property (nonatomic, assign) NSUInteger selectedIndex;

//  A scroll view to display menu choices
@property (nonatomic, strong) UIScrollView *scrollView;

//  A carat to show which item is selected.
@property (nonatomic, strong) UIView *carat;

@end

@implementation MBMenuView

- (id)init{
    self = [super init];
    
    if (self) {
        _selectedIndex = 0;
    }
    
    return self;
}

- (void)showInView:(UIView *)view{
//    
//    [self setMaxHeight:200];
//    [self setMaxWidth:140];
//    [self setDimensionStyle:MBDialogDimensionsNarrowShort];
    
//    [super showInView:view atVerticalPosition:MBPositionTop andHorizontalPosition:MBPositionRight withAnimation:MBDialogViewAnimationPop];
}


- (void)render{
   
    //
    //  Prepare and render a scroll view
    //
    
    if (![self scrollView]) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[self labelFrame]];
        [scrollView setContentSize:[scrollView frame].size];
        [self setScrollView:scrollView];
        [[self scrollView] setBounces:YES];
    }
    
    [[self scrollView] setFrame:[self labelFrame]];
    [[self scrollView] setBounds:[self labelFrame]];
    
    [self addSubview:[self scrollView]];

    //  Remove the old labels from the scroll view
    //  We use a block here so we don't remove the scroll bars.
    [[[self scrollView] subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    //
    //  Render/update the carat
    //
    
    [self renderCarat];

    //
    //  Render out the labels
    //
    
    const float margin = 6;
    
    NSUInteger numberOfNodes = [[self nodes] count];
    
    for (NSUInteger i = 0; i < numberOfNodes; i++) {
    
        CGRect labelFrame = CGRectMake(margin*2, i * (22 + margin/2), [[self scrollView] bounds].size.width-margin, 22);
        
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        
        [label setBackgroundColor:[UIColor clearColor]];
        
        MBDialogTreeNode *node = [self nodes][i];
        
        NSString *title = [node displayName];

        [label setText:title];
        
        [[self scrollView] addSubview:label];
    }
    
    CGSize size = CGSizeMake([self scrollView].frame.size.width, numberOfNodes * margin * 2);
    [[self scrollView] setContentSize:size];
}

//
//  Renders the selection carat,
//  creating it if necessary, otherwise
//  simply moving it into place in
//  next to the selected item.
//

- (void) renderCarat{
    
    const float caratSideLength = 10;
    
    const float caratMargin = 6;
    
    //
    //  Create a carat 
    //
    
    if (![self carat]) {
        UIView *caratView = [[UIView alloc] initWithFrame:CGRectMake(0, caratMargin/2, caratSideLength, caratSideLength)];
        [[caratView layer] setBackgroundColor:[UIColor blackColor].CGColor];
        [[caratView layer] setCornerRadius:10];
        [self setCarat:caratView];
    }
    
    //
    //  Move the carat into the correct position
    //
    
    CGRect caratFrame = [[self carat] frame];
    
    caratFrame.origin.y = [self selectedIndex] * caratSideLength + (caratMargin);
    
    //
    //  Ensure the carat is in the view hierarchy
    //
    
    [[self scrollView] addSubview:[self carat]];
    
    //
    //  Move the carat into place
    //
    
    [UIView animateWithDuration:0.3 animations:^{
        [[self carat] setFrame:caratFrame];
        [[self carat] setBounds:caratFrame];
    }];
}

- (void) setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self renderCarat];
}

@end
