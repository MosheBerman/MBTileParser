//
//  MBGameController.m
//  TileParser
//
//  Created by Moshe Berman on 5/7/17.
//
//

#import "MBGameController.h"
#import "MBControllerOutput.h"

@interface MBGameController () <MBControllerInput>

@property (nonatomic, strong) GCController *controller;
@property (nonatomic, strong) NSMutableSet <MBControllerOutput> *observers;

@end

@implementation MBGameController 

- (instancetype)init
{
    self = [super init];
    if (self) {
        _observers = [NSMutableSet<MBControllerOutput> set];
        [self _observeControllerChanges];
    }
    return self;
}

// MARK: - Scanning For New Controllers

-(void)pickBestController;
{
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
       
        // Handled below, so do nothing here.
        
    }];
}

- (void)_observeControllerChanges
{
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_controllerConnected:) name:GCControllerDidConnectNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_controllerDisconnected:) name:GCControllerDidDisconnectNotification object:nil];
}

// MARK: - Handle Controller Connect/Disconnect

- (void)_controllerConnected:(NSNotification *)notification
{
    NSArray <GCController *>* controllers = [GCController controllers];
    
    for (GCController * controller in controllers)
    {
        if (controller.microGamepad)
        {
            self.controller = controller;
            self.controller.microGamepad.allowsRotation = YES;
            
            __weak MBGameController *weakSelf = self;
            
            self.controller.microGamepad.buttonA.pressedChangedHandler = ^(GCControllerButtonInput * _Nonnull button, float value, BOOL pressed)
            {
                if (weakSelf)
                {
                    MBGameController *c = weakSelf;
                    
                    if (pressed)
                    {
                        [c dispatchButtonPressedNotificationWithSender:MBControllerInputButtonA];
                    }
                    else
                    {
                        [c dispatchButtonReleasedNotificationWithSender:MBControllerInputButtonA];
                    }
                }
            };
            
            self.controller.microGamepad.dpad.valueChangedHandler = ^(GCControllerDirectionPad * _Nonnull dpad, float xValue, float yValue) {
                
                if (weakSelf)
                {
                    MBGameController *c = weakSelf;
                    
                    [c dispatchJoystickChangedNotificationWithVelocity:CGPointMake(xValue, yValue)];
                    
                }
            };
            
            self.controller.microGamepad.buttonX.pressedChangedHandler = ^(GCControllerButtonInput * _Nonnull button, float value, BOOL pressed) {
                
                if(weakSelf)
                {
                    MBGameController *c = weakSelf;
                    
                    if (pressed)
                    {
                        [c dispatchButtonPressedNotificationWithSender:MBControllerInputButtonX];
                    }
                    else
                    {
                        [c dispatchButtonReleasedNotificationWithSender:MBControllerInputButtonX];
                    }
                }
            };
            
            break;
        }
    }
    
}

- (void)_controllerDisconnected:(NSNotification *)notification
{
    NSArray *controllers = [GCController controllers];
    
    if (controllers.count == 0)
    {
        // TODO: Show something requiring a controller to connect.
    }
}

- (void)addObserver:(id)observer{
    [[self observers] addObject:observer];
}

- (void)removeObserver:(id)observer{
    if ([[self observers] containsObject:observer]) {
        [[self observers] removeObject:observer];
    }
}

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


@end
