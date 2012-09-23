//
//  MBViewController.m
//  TileParser
//
//  Created by Moshe Berman on 7/16/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import "MBViewController.h"

#import "MBGameEngine/MBGameEngine.h"

#import "UIView+Diagnostics.h"

@interface MBViewController () <MBControllerEvent, MBSpriteMovementDelegate>

@property (nonatomic, strong) MBSpriteView *player;
@property (nonatomic, strong) MBMapViewController *mapViewController;
@property (nonatomic, strong) MBGameBoyViewController *gameboyControls;
@property (nonatomic, strong) MBDialogView *dialogView;
@property (nonatomic) BOOL isShowingDialog;

@end

@implementation MBViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    
    if (self) {
        _isShowingDialog = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
    
    [mapViewController.mapView addSprite:sprite forKey:@"player" atTileCoordinates:CGPointMake(8,7) beneathLayerNamed:@"TreeTops"];
    [[mapViewController mapView] beginFollowingSpriteForKey:@"player"];
    
    //
    //  Add and configure a self-moving sprite
    //
    
    MBSelfMovingSpriteView *movingSprite = [[MBSelfMovingSpriteView alloc] initWithSpriteName:@"tuna_guy"];
    [[mapViewController mapView] addSprite:movingSprite forKey:@"movingSprite" atTileCoordinates:CGPointMake(7, 7) beneathLayerNamed:@"TreeTops"];
    
    //  Attach the map to the sprite as the movement delegate
    [movingSprite setMovementDelegate:self];
    [movingSprite setMovementDataSource:[self mapViewController]];
    
    //
    //  Set up the game controls
    //
    
    MBGameBoyViewController *controller = [[MBGameBoyViewController alloc] init];
    [self setGameboyControls:controller];
    [controller addObserver:[self player]];
    [controller addObserver:self];
    [[self view] addSubview:[controller view]];
    
    //
    //  Trigger automatic motion
    //
    
    [movingSprite moveInRandomDirection];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //    [self.view displayBorderOfColor:[UIColor redColor] onSubviewsOfView:self.view];
    //    [self.view displayBorderOfColor:[UIColor redColor] onSubviewsOfView:self.gameboyControls.view];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    } else {
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
        return UIInterfaceOrientationMaskAll;
    }
}


#pragma mark - Controller Delegate

- (void)gameController:(MBControllerViewController *)controller buttonPressedWithSender:(id)sender{
    if ([sender isEqual:[[self gameboyControls] buttonA]]) {
        
    }else if ([sender isEqual:[[self gameboyControls] buttonB]]) {
        
    }
}

- (void)gameController:(MBControllerViewController *)controller buttonReleasedWithSender:(id)sender{
    if ([sender isEqual:[[self gameboyControls] buttonA]]) {
        
        if(![self dialogView]){
            MBDialogView *dialogView = [[MBDialogView alloc] initWithText:@"Welcome to Moflotz. You can walk around with the D pad in the bottom left corner. Press A to show this again, press B to dismiss."];
            [self setDialogView:dialogView];
        }
        
        if ([self isShowingDialog]) {
            [self setIsShowingDialog:NO];
            [[self dialogView] removeFromSuperview];
        }else{
            [self setIsShowingDialog:YES];
            [[self dialogView] showInView:[self view]];
        }
    }else if ([sender isEqual:[[self gameboyControls] buttonB]]) {
        
        if ([self dialogView]) {
            [self setIsShowingDialog:NO];
            [[self dialogView] removeFromSuperview];
        }
        
    }
}

- (void)gameController:(MBControllerViewController *)controller joystickValueChangedWithSender:(id)value{
    
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
    
    //  Freeze movement during dialog.
    
    if ([self isShowingDialog]) {
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
//  Disable turning for specific characters or whatnot here.
//  For example, to freeze characters if dialog is thrown onscreen.
//

- (BOOL)spriteCanTurn:(MBSpriteView *)sprite toFaceDirection:(MBSpriteMovementDirection)direction{
    return ![self isShowingDialog];
}

- (void)sprite:(MBSpriteView *)sprite interactWithTileAtCoordinates:(CGPoint)coordinates{
    
    if (coordinates.x < 0 || coordinates.y < 0)  {
        return;
    }
    
    //  Get a rect covering the target tile
    //CGRect targetLocation = CGRectMake(coordinates.x * tileSize.width, coordinates.y * tileSize.height, (coordinates.x+1) * tileSize.width, (coordinates.y+1) * tileSize.height);
    
}



#pragma mark - Dialog Delegate

@end
