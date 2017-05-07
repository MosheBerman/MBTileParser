//
//  MBControllerEvent.h
//  TileParser
//
//  Created by Moshe Berman on 8/27/12.
//
//

#import <Foundation/Foundation.h>
#import "MBControllerInput.h"

@protocol MBControllerOutput <NSObject>

- (void)gameController:(id<MBControllerInput>)controller buttonPressedWithSender:(MBControllerInputButton)sender;
- (void)gameController:(id<MBControllerInput>)controller buttonReleasedWithSender:(MBControllerInputButton)sender;
- (void)gameController:(id<MBControllerInput>)controller joystickValueChangedWithVelocity:(CGPoint)velocity;

@end
