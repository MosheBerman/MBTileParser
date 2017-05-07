//
//  MBControllerViewController.m
//  TileParser
//
//  Created by Moshe Berman on 8/26/12.
//
//

#import "MBControllerViewController.h"

#import "MBControllerOutput.h"

#import "MBJoystickView.h"

#import "MBControllerButton.h"

@interface MBControllerViewController () <MBControllerInput>
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
        return UIInterfaceOrientationMaskAll;
    }
}

#pragma mark - Input Notifications

- (void)dispatchButtonPressedNotificationWithSender:(MBControllerInputButton)sender{
    for (id<MBControllerOutput> observer in [self observers]) {
        [observer gameController:self buttonPressedWithSender:sender];
    }
}

- (void)dispatchButtonReleasedNotificationWithSender:(MBControllerInputButton)sender{
    for (id<MBControllerOutput> observer in [self observers]) {
        [observer gameController:self buttonReleasedWithSender:sender];
    }
}

- (void)dispatchJoystickChangedNotificationWithVelocity:(CGPoint)velocity{
    for (id<MBControllerOutput> observer in [self observers]) {
        [observer gameController:self joystickValueChangedWithVelocity:velocity];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isKindOfClass:[MBJoystickView class]]) {
        if ([keyPath isEqual:@"velocity"]) {
            
            MBJoystickView *joystick = object;
            [self dispatchJoystickChangedNotificationWithVelocity:joystick.velocity];
        }
    }else if ([object isKindOfClass:[MBControllerButton class]]){
        if ([keyPath isEqual:@"isPressed"]) {
            
            MBControllerButton *button = object;
            MBControllerInputButton buttonType = MBControllerInputButtonA;
            
            if ([button.titleLabel.text isEqualToString:@"B"])
            {
                buttonType = MBControllerInputButtonX;
            }
            
            if ([(MBControllerButton *)object isPressed]) {
                [self dispatchButtonPressedNotificationWithSender:buttonType];
            }else{
                [self dispatchButtonReleasedNotificationWithSender:buttonType];
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
