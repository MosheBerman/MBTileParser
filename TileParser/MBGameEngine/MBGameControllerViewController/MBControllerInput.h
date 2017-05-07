//
//  MBControllerInput.h
//  TileParser
//
//  Created by Moshe Berman on 5/7/17.
//
//

#ifndef MBControllerInput_h
#define MBControllerInput_h

typedef NS_ENUM(NSUInteger, MBControllerInputButton) {
    MBControllerInputButtonA,
    MBControllerInputButtonX,
    MBControllerInputButtonY,
    MBControllerInputButtonZ,
    MBControllerInputButtonL,
    MBControllerInputButtonR
};

@protocol MBControllerInput <NSObject>

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

- (void)dispatchButtonPressedNotificationWithSender:(MBControllerInputButton)sender;
- (void)dispatchButtonReleasedNotificationWithSender:(MBControllerInputButton)sender;
- (void)dispatchJoystickChangedNotificationWithVelocity:(CGPoint)sender;

@end

#endif /* MBControllerInput_h */
