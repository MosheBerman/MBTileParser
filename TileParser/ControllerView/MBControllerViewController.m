//
//  MBControllerViewController.m
//  TileParser
//
//  Created by Moshe Berman on 8/26/12.
//
//

#import "MBControllerViewController.h"

#import "MBControllerEvent.h"

@interface MBControllerViewController ()
@property (nonatomic, strong) NSMutableSet *observers;
@end

@implementation MBControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _observers = [NSMutableSet set];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dispatchButtonPressedNotificationWithSender:(id)sender{
    for (id<MBControllerEvent> observer in [self observers]) {
        [observer gameController:self buttonsPressedWithSender:sender];
    }
}

- (void) dispatchButtonReleasedNotificationWithSender:(id)sender{
    for (id<MBControllerEvent> observer in [self observers]) {
        [observer gameController:self buttonsReleasedWithSender:sender];
    }
}

- (void) dispatchJoystickChangedNotificationWithSender:(id)sender{
    for (id<MBControllerEvent> observer in [self observers]) {
        [observer gameController:self joystickValueChangedWithSender:sender];
    }
}

//
//
//

- (void) addObserver:(id)observer{
    [[self observers] addObject:observer];
}

- (void) removeObserver:(id)observer{
    if ([[self observers] containsObject:observer]) {
        [[self observers] removeObject:observer];
    }
}

@end
