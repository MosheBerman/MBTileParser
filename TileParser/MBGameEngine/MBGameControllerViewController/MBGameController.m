//
//  MBGameController.m
//  TileParser
//
//  Created by Moshe Berman on 5/7/17.
//
//

#import "MBGameController.h"

@interface MBGameController ()

@property (nonatomic, strong) GCController *controller;

@end

@implementation MBGameController 

- (instancetype)init
{
    self = [super init];
    if (self) {
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
            
            self.controller.microGamepad.buttonA.pressedChangedHandler = ^(GCControllerButtonInput * _Nonnull button, float value, BOOL pressed)
            {
                
            };
            
            self.controller.microGamepad.dpad.valueChangedHandler = ^(GCControllerDirectionPad * _Nonnull dpad, float xValue, float yValue) {
                
            };
            
            self.controller.microGamepad.buttonX.pressedChangedHandler = ^(GCControllerButtonInput * _Nonnull button, float value, BOOL pressed) {
                
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

// MARK: -

- (void)addObserver:(id)observer
{
    
}

- (void)removeObserver:(id)observer;
{
    
}

- (void)dispatchButtonPressedNotificationWithSender:(id)sender;
{
    
}

- (void)dispatchButtonReleasedNotificationWithSender:(id)sender;
{
    
}

- (void)dispatchJoystickChangedNotificationWithSender:(id)sender;
{
    
}

@end
