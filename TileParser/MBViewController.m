//
//  MBViewController.m
//  TileParser
//
//  Created by Moshe Berman on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBViewController.h"

#import "MBMapView.h"
#import "MBSpriteView.h"
#import "MBSpriteParser.h"

@interface MBViewController ()

@end

@implementation MBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    MBMapView *map = [[MBMapView alloc] initWithFrame:self.view.frame mapName:@"SimpsonCity"];
    
    [self.view addSubview:map];
    
    map.minimumZoomScale = 1.0;
    map.maximumZoomScale = 3.0;
    
	
	MBSpriteView *sprite = [MBSpriteParser spriteViewWithSpriteName:@"nikkie"];
    [map addSprite:sprite forKey:@"player" atTileCoordinates:CGPointMake(4,0) beneathLayerNamed:@"TreeTops"];
    
	[sprite setDirection:@"down"];
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
