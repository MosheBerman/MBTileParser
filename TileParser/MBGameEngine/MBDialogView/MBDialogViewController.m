//
//  MBDialogViewController.m
//  TileParser
//
//  Created by Moshe Berman on 11/1/12.
//
//

#import "MBDialogViewController.h"

#import "MBDialogTree.h"

#import "NSString+MBDialogString.h"

#import "UIApplication+MBDialog.h"

@interface MBDialogViewController ()

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

@implementation MBDialogViewController

- (id)initWithDialogTree:(MBDialogTree *)tree
{
    self = [super init];
    
    if (self) {
        _dialogTree = tree;
        _cacheIndex = 0;
    }
    
    return self;
}


- (void)loadView
{
    
    MBDialogView *d = [[MBDialogView alloc] init];
    
    [self setView:d];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   [self prepareCache];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Present the MBDialogView
//
//  Shows the dialog view in the root view
//  with a pop animation type.
//

- (void)show
{
    [self showWithAnimation:MBDialogViewAnimationPop];
}

//
//  Shows the dialog view in the root view
//  with a supplies animation type.
//


- (void)showWithAnimation:(MBDialogAnimation)animationType
{
    
    UIView *parentView = [UIApplication rootView];
    
    MBDialogView *view = (MBDialogView *)[self view];
    
    [view showInView:parentView withAnimation:animationType];
    
    [self prepareCache];
}

- (BOOL) isShowing
{
    return [[[UIApplication rootView] subviews] containsObject:[self view]];
}

#pragma mark - Text loading and caching

//
//  Cache the text and show the first part of it.
//
//  Dialog caching only works in the base class.
//  Subclasses of the dialog class do not
//  support caching.
//

- (void) prepareCache
{
    
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

- (void) cacheText
{
    MBDialogTreeNode *node = [[self dialogTree] activeNode];
    
    NSString *textToCache = [node nextStringToDisplay];

    if(textToCache)
    {
        //  Only cache if we actually want to cache stuff.
        
        CGRect frame = [[[self dialogView] contentView] frame];
        UIFont *font = [[self dialogView] font];
        
        NSArray *newDialog = [textToCache dialogArrayForFrame:frame andFont:font];
        [self setCacheOfCurrentNode:newDialog];
        
        [self setCacheIndex:0];
    }
    else
    {
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

- (void) cycleText
{
    
    NSString *textToRender = [self nextStringFromCache];
    
    if (textToRender)
    {
        [[self dialogView] setText:textToRender];
        [[self dialogView] render];
    }
    else
    {
        
        //
        //  Store the end action
        //
        
        SEL endAction = [[[self dialogTree] activeNode] endAction];
        
        //
        //  Hide the dialog tree
        //
        
        [[self dialogView] hide];
        
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

#pragma mark - Cycle Current Node

//
//  Check if our temporary dialog tree has more text,
//  if not we check the actual dialog tree.
//

- (BOOL)hasNextInCache
{
    return [self cacheIndex] < [[self cacheOfCurrentNode] count];
}

//
//  Load the next string out of the cache
//

- (NSString *)nextStringFromCache
{
    NSUInteger index = [self cacheIndex];
    NSString *string = [self cacheOfCurrentNode][index];
    if ([self hasNextInCache]) {
        index++;
        [self setCacheIndex:index];
    }
    return string;
}

@end
