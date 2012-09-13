//
//  MBViewController.m
//  TileParser
//
//  Created by Moshe Berman on 7/16/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import "MBViewController.h"

#import "MBMapViewController.h"

#import "MBMovableSpriteView.h"

#import "MBSelfMovingSpriteView.h"

#import "MBGameBoyViewController.h"

#import "UIView+Diagnostics.h"

@interface MBViewController ()
@property (nonatomic, strong) MBSpriteView *player;
@property (nonatomic, strong) MBMapViewController *mapViewController;
@property (nonatomic, strong) MBGameBoyViewController *gameboyControls;

@end

@implementation MBViewController

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
     [sprite setMovementDelegate:mapViewController];
     
    
    //  Add the sprite to the map and follow it
    
    [mapViewController.mapView addSprite:sprite forKey:@"player" atTileCoordinates:CGPointMake(8,7) beneathLayerNamed:@"TreeTops"];
    [[mapViewController mapView] beginFollowingSpriteForKey:@"player"];
    
    //
    //  Add and configure a self-moving sprite
    //
    
    MBSelfMovingSpriteView *movingSprite = [[MBSelfMovingSpriteView alloc] initWithSpriteName:@"tuna_guy"];
    [[mapViewController mapView] addSprite:movingSprite forKey:@"movingSprite" atTileCoordinates:CGPointMake(7, 7) beneathLayerNamed:@"TreeTops"];
    
    //  Attach the map to the sprite as the movement delegate    
    [movingSprite setMovementDelegate:mapViewController];
    
    //
    //  Set up the game controls
    //
    
    MBGameBoyViewController *controller = [[MBGameBoyViewController alloc] init];
    [self setGameboyControls:controller];
    [controller addObserver:[self player]];
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



@end
