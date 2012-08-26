//
//  MBViewController.m
//  TileParser
//
//  Created by Moshe Berman on 7/16/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import "MBViewController.h"
#import "MBMapViewController.h"
#import "MBSpriteParser.h"

@interface MBViewController () <MBSpriteMovementDelegate>
@property (nonatomic, strong) MBSpriteView *player;
@property (nonatomic, strong) MBMapViewController *mapViewController;
@end

@implementation MBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    MBMapViewController *mapViewController = [[MBMapViewController alloc] initMapName:@"SimpsonCity"];
    [[mapViewController mapView] setMaximumZoomScale:2.0];
    [self.view addSubview:[mapViewController view]];
    
    MBSpriteView *sprite = [MBSpriteParser spriteViewWithSpriteName:@"explorer"];
    
    [self setPlayer:sprite];
    
    [sprite setMovementDelegate:self];
    
    [mapViewController.mapView addSprite:sprite forKey:@"player" atTileCoordinates:CGPointMake(6,4) beneathLayerNamed:@"TreeTops"];
    [sprite beginAnimation:@"down"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[self player] moveUpWithCompletion:^{
            [[self player] moveLeftWithCompletion:^{
                [[self player] moveDownWithCompletion:^{
                    [[self player] moveRightWithCompletion:^{
                        [[self player] setDirection:@"down"];
                    }];
                }];
            }];
    }];
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

#pragma mark - Movement Delegate

- (CGSize) tileSizeInPoints{
    
    //TODO: Get size of a tile from the mapview somehow

    //TODO: remove this when the delegate is implemented...
    return CGSizeMake(32.0, 32.0);
}

- (BOOL) tileIsOpenAtCoordinates:(CGPoint)coordinates{
    // Figure out if a tile is open at some point
}

@end
