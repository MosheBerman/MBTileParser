//
//  MBViewController.m
//  TileParser
//
//  Created by Moshe Berman on 7/16/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

@import CoreGraphics;

#import "MBViewController.h"

#import "MBGameEngine/MBGameEngine.h"

#import "UIView+Diagnostics.h"

@interface MBViewController () <MBControllerOutput, MBSpriteMovementDelegate>

@property (nonatomic, strong) MBMovableSpriteView *player;
@property (nonatomic, strong) MBMapViewController *mapViewController;

#if TARGET_OS_TV
@property (nonatomic, strong) MBGameController* controller;
#else 
@property (nonatomic, strong) MBGameBoyViewController *gameboyControls;
#endif

@property (nonatomic, strong) MBDialogView *dialogView;
@property (nonatomic, strong) MBMenuView *menuView;

@end

@implementation MBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 
    [self setupGame];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    } else {
        return YES;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
        return UIInterfaceOrientationMaskAll;
    }
}

#pragma mark - Game Controller Delegate

- (void)gameController:(id<MBControllerInput>)controller buttonPressedWithSender:(MBControllerInputButton)sender{
    if (sender == MBControllerInputButtonA)
    {
        
    }
    else if (sender == MBControllerInputButtonX)
    {
        
    }
}

- (void)gameController:(id<MBControllerInput>)controller buttonReleasedWithSender:(MBControllerInputButton)sender
{
    if (sender == MBControllerInputButtonA)
    {
        if(![[self dialogView] isShowing] && ![self isShowingMenu])
        {
            MBDialogTree *tree = [self dialogTreeWithIdentifier:0];
            MBDialogView *dialogView = [[MBDialogView alloc] initWithDialogTree:tree];
            [self setDialogView:dialogView];
            
            [[self dialogView] show];
        }
        else if ([[self dialogView] isShowing])
        {
            [[self dialogView] cycleText];
        }
        else{
            [[self dialogView] show];
        }
    }
    else if (sender == MBControllerInputButtonX)
    {
        if ([[self dialogView] isShowing])
        {
            [[self dialogView] cycleText];
        }

    }
}

- (void)gameController:(id<MBControllerInput>)controller joystickValueChangedWithVelocity:(CGPoint)velocity
{
    
}

#pragma mark - Movement Delegate

//
//  Here's where you would check for movement off the edges of your world.
//  You might also want to do collision detection with the other sprites, and
//  handle special tile metadata, as per your game logic.
//

// FIXME: Make a flag to indicate if we're moving based on velocity or per-tile increments.

- (BOOL)sprite:(MBSpriteView *)sprite canMoveToCoordinates:(CGPoint)coordinates {
    
    //  Disallow movement off the top and left edges.
    
    if (coordinates.x < 0 || coordinates.y < 0)  {
        return NO;
    }
    
    //  Disallow movement off the bottom and right edges.
    
    CGSize mapDimensions = [[self mapViewController] mapSizeInTiles];
    
    if (coordinates.y >= mapDimensions.height || coordinates.x >= mapDimensions.width) {
        
        return NO;
    }
    
    //  Freeze movement during dialog & menu.
    
    if ([[self dialogView] isShowing] || [self isShowingMenu]) {
        return NO;
    }
    
    CGSize tileSize = [[self mapViewController] tileSizeInPoints];
    
    //  Get a rect covering the target tile...
    
    CGRect targetLocation = CGRectMake(coordinates.x * tileSize.width, coordinates.y * tileSize.height, tileSize.width,  tileSize.height);
    
    //  ... use it to check for other sprites...
    
    for (MBSpriteView *aSprite in [[[[self mapViewController] mapView] sprites] allValues]) {
        if (CGRectIntersectsRect(aSprite.frame, targetLocation) && aSprite != sprite) {
            return NO;
        }
    }
    
    //  and check tile metadata.
    
    NSDictionary *tileProperties = [[self mapViewController] propertiesForTileInLayer:@"Meta" atCoordinates:coordinates];
    
    if ([tileProperties[@"name"] isEqualToString:@"solid"]) {
        return NO;
    }
    
    if ([tileProperties[@"name"] isEqualToString:@"water"]) {
        return NO;
    }
    
    if ([tileProperties[@"name"] isEqualToString:@"message"] && sprite != [self player]) {
        return NO;
    }
    
    return YES;
}

//
//  Act after a sprite moves to given coordinates
//

- (void) sprite:(MBSpriteView *)sprite didMoveToCoordinates:(CGPoint)coordinates{
    
}

//
//  Disable turning for specific characters or whatnot here.
//  For example, to freeze characters if dialog is thrown onscreen.
//

- (BOOL)sprite:(MBSpriteView *)sprite canTurnToFaceDirection:(MBSpriteMovementDirection)direction{
    return ![[self dialogView] isShowing] && ![self isShowingMenu];
}

- (void)sprite:(MBSpriteView *)sprite interactWithTileAtCoordinates:(CGPoint)coordinates{
    
    //
    //  Avoid interactions with the tiles outside the map's bounderies
    //
    
    CGSize mapDimensions = [[self mapViewController] mapSizeInTiles];
    CGSize tileDimensions = [[self mapViewController] tileSizeInPoints];
    
    CGPoint coordinatesInTiles = coordinates;
    coordinatesInTiles.x /= tileDimensions.width;
    coordinatesInTiles.y /= tileDimensions.height;
    
    if (coordinatesInTiles.x < 0 || coordinatesInTiles.y < 0)
    {
        return;
    }
    else if (coordinatesInTiles.y > mapDimensions.height || coordinatesInTiles.x > mapDimensions.width)
    {
        return;
    }
    
    //  Get a rect covering the target tile
    CGRect targetLocation = CGRectMake(coordinates.x, coordinates.y, coordinates.x + tileDimensions.width, coordinates.y+ tileDimensions.height);
    
    CGPoint tileCenter = targetLocation.origin;
    tileCenter.x += tileDimensions.width/2;
    tileCenter.y += tileDimensions.height/2;
    
    NSDictionary *connectionProperties = [[self mapViewController] propertiesForObjectInGroupNamed:@"Connections" atPoint:tileCenter];
    
    if (connectionProperties != nil)
    {
        
        NSString *directionName = connectionProperties[@"name"];
        NSString *mapName = connectionProperties[@"value"];
        
        if([[[self player] directionKey] isEqualToString:directionName])
        {
            //
            //  TODO: We want to load the new map state here...
            //
            
            [[self mapViewController] loadMap:mapName];
            
        }
    }
    
}



#pragma mark - Dialog Tree Setup

//
//  This method loads up a dialog tree for a supplied identifier
//

- (MBDialogTree *)dialogTreeWithIdentifier:(NSUInteger)identifier
{
    
    //
    //  Prepare the dialog nodes
    //
    
    NSArray *aboutDialog = @[@"Welcome to MBTileParser. You can walk around with the D pad in the bottom left corner. Press A to show this again, press B to dismiss.", @"More text."];
    
    SEL aboutEndAction = NSSelectorFromString(@"showMenu");
    
    SEL cancelAction = NSSelectorFromString(@"hideMenu");
    
    //
    //  Create and set up the nodes.
    //
    
    MBDialogTreeNode *aboutNode = [[MBDialogTreeNode alloc] init];
    
    [aboutNode setDialog:aboutDialog];
    [aboutNode setEndAction:aboutEndAction];
    [aboutNode setDisplayName:@"About"];
    
    MBDialogTreeNode *cancelNode = [[MBDialogTreeNode alloc] init];
    [cancelNode setEndAction:cancelAction];
    [cancelNode setDisplayName:@"Cancel"];
    [cancelNode setDialog:nil];
    
    //
    //  Create and return the tree
    //
    
    MBDialogTree *tree = [[MBDialogTree alloc] initWithNodes:@[aboutNode, cancelNode]];
    
    return tree;
}

#pragma mark - Game Setup

- (void)setupGame
{
    //
    //  Create a map view controller and display the map
    //
    
    MBMapViewController *mapViewController = [[MBMapViewController alloc] initWithMapName:@"SimpsonCity"];
    [[mapViewController mapView] setMaximumZoomScale:2.0];
    [self setMapViewController:mapViewController];
    [self.view addSubview:[mapViewController view]];
    
    //
    //  Create a sprite for the game world.
    //
    
    MBMovableSpriteView *sprite = [[MBMovableSpriteView alloc] initWithSpriteName:@"explorer"];
    [self setPlayer:sprite];
    [sprite setMovementDelegate:self];
    [sprite setMovementDataSource:[self mapViewController]];
    
    //  Add the sprite to the map and follow it
    
    [mapViewController.mapView addSprite:sprite forKey:@"player" atTileCoordinates:CGPointMake(6,6) beneathLayerNamed:@"TreeTops"];
    
    //
    //  Add and configure a self-moving sprite
    //
    
    MBSelfMovingSpriteView *movingSprite = [[MBSelfMovingSpriteView alloc] initWithSpriteName:@"tuna_guy"];
    [[mapViewController mapView] addSprite:movingSprite forKey:@"movingSprite" atTileCoordinates:CGPointMake(7, 7) beneathLayerNamed:@"TreeTops"];
    
    //  Attach the map to the sprite as the movement delegate
    [movingSprite setMovementDelegate:self];
    [movingSprite setMovementDataSource:[self mapViewController]];
    
#if TARGET_OS_TV
    
    MBGameController *controller = [[MBGameController alloc] init];
    [controller addObserver:[self player]];
    [controller addObserver:self];
    self.controller = controller;
    [self.controller pickBestController];
    
#else
    //
    //  Set up the game controls
    //
    
    MBGameBoyViewController *controller = [[MBGameBoyViewController alloc] init];
    [self setGameboyControls:controller];
    [controller addObserver:[self player]];
    [controller addObserver:self];
    [[self view] addSubview:[controller view]];
#endif
    
    //
    //  Trigger automatic motion
    //
    
    [movingSprite faceInRandomDirection];
    
    //
    //  Stalk the player
    //
    
    [[[self mapViewController] mapView] beginFollowingSpriteForKey:@"player"];
}

#pragma mark - Dialog/Menu Detection

//
//  Check if the menu is being shown in the
//  main view controller's view hierarchy.
//

- (BOOL)isShowingMenu
{
    UIView *menuView = [self menuView];
    BOOL isShowing = [[[self view] subviews] containsObject:menuView];
    return isShowing;
}

#pragma mark - Actions 

- (void)showAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hello" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil]];
    [self presentViewController:alertController animated:YES completion:false];
    
}

- (void)showMenu
{
    
    if(![self menuView])
    {
        MBMenuView *menu = [[MBMenuView alloc] init];
        [self setMenuView:menu];
    }
    
    if (![self isShowingMenu])
    {
        [[self menuView] showInView:[self view]];
    }

}

@end
