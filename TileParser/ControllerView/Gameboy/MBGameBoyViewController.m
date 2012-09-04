//
//  MBGameBoyViewController.m
//  TileParser
//
//  Created by Moshe Berman on 8/27/12.
//
//

#import "MBGameBoyViewController.h"

@interface MBGameBoyViewController ()

@end

@implementation MBGameBoyViewController

- (id) init{

    self = [super init];
    
    if (self) {
        
        _joystick = [[MBJoystickView alloc] initWithFrame:CGRectMake(32, 224, 64, 64)];
        
        _buttonA = [MBControllerButton buttonWithColor:[UIColor whiteColor]];
        _buttonB = [MBControllerButton buttonWithColor:[UIColor whiteColor]];
        
        _buttonStart = [MBControllerButton buttonWithColor:[UIColor whiteColor]];
        _buttonSelect = [MBControllerButton buttonWithColor:[UIColor whiteColor]];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self observeControls];    
    [self displayControls];
    [self layoutControls];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self view] setFrame:[[[self view] superview] bounds]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Autorotation

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

#pragma mark - Controler

- (void) observeControls{
    [[self joystick] addObserver:self forKeyPath:@"velocity" options:NSKeyValueObservingOptionNew context:nil];
    [[self joystick] addObserver:self forKeyPath:@"stickPosition" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)hideControls{
    [[self joystick] removeFromSuperview];
    [[self buttonA] removeFromSuperview];
    [[self buttonB] removeFromSuperview];
    [[self buttonSelect] removeFromSuperview];
    [[self buttonStart] removeFromSuperview];
}

- (void)displayControls{
    [[self view] addSubview:[self joystick]];
    
    /*
    [[self view] addSubview:[self buttonA]];
    [[self view] addSubview:[self buttonB]];
    [[self view] addSubview:[self buttonStart]];
    [[self view] addSubview:[self buttonSelect]];
     */
}

- (void) layoutControls{
    
    //
    //  TODO: Use Autolayout in here
    //
    
}

@end
