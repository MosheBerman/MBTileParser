//
//  MBControllerViewController.m
//  TileParser
//
//  Created by Moshe Berman on 8/26/12.
//
//

#import "MBControllerViewController.h"

#import "MBControllerEvent.h"

#import "MBJoystickView.h"

#import "MBControllerButton.h"

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

#pragma mark - Input Notifications

- (void)dispatchButtonPressedNotificationWithSender:(id)sender{
    for (id<MBControllerEvent> observer in [self observers]) {
        [observer gameController:self buttonPressedWithSender:sender];
    }
}

- (void)dispatchButtonReleasedNotificationWithSender:(id)sender{
    for (id<MBControllerEvent> observer in [self observers]) {
        [observer gameController:self buttonReleasedWithSender:sender];
    }
}

- (void)dispatchJoystickChangedNotificationWithSender:(id)sender{
    for (id<MBControllerEvent> observer in [self observers]) {
        [observer gameController:self joystickValueChangedWithSender:sender];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isKindOfClass:[MBJoystickView class]]) {
        if ([keyPath isEqual:@"velocity"]) {
            [self dispatchJoystickChangedNotificationWithSender:object];        
        }
    }else if ([object isKindOfClass:[MBControllerButton class]]){
        if ([keyPath isEqual:@"isPressed"]) {
            if ([(MBControllerButton *)object isPressed]) {
                [self dispatchButtonPressedNotificationWithSender:object];
            }else{
                [self dispatchButtonReleasedNotificationWithSender:object];
            }
        }
    }
}

#pragma mark - Input Observers

- (void)addObserver:(id)observer{
    [[self observers] addObject:observer];
}

- (void)removeObserver:(id)observer{
    if ([[self observers] containsObject:observer]) {
        [[self observers] removeObject:observer];
    }
}

@end
