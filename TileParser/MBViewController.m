//
//  MBViewController.m
//  TileParser
//
//  Created by Moshe Berman on 7/16/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import "MBViewController.h"

#import "MBMapViewController.h"
#import "MBSpriteView.h"
#import "MBSpriteParser.h"

@interface MBViewController ()

@end

@implementation MBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    MBMapViewController *mapViewController = [[MBMapViewController alloc] initMapName:@"SimpsonCity"];
    [[mapViewController view] setMaximumZoomScale:2.0];
    [self.view addSubview:[mapViewController view]];

	MBSpriteView *sprite = [MBSpriteParser spriteViewWithSpriteName:@"explorer"];
    [mapViewController.mapView addSprite:sprite forKey:@"player" atTileCoordinates:CGPointMake(6,4) beneathLayerNamed:@"TreeTops"];
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
