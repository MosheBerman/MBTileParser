//
//  MBControllerEvent.h
//  TileParser
//
//  Created by Moshe Berman on 8/27/12.
//
//

#import <Foundation/Foundation.h>

@class MBControllerViewController;

@protocol MBControllerEvent <NSObject>

- (void) gameController:(MBControllerViewController *)controller buttonsPressedWithSender:(id)sender;
- (void) gameController:(MBControllerViewController *)controller buttonsReleasedWithSender:(id)sender;
- (void) gameController:(MBControllerViewController *)controller joystickValueChangedWithSender:(id)value;

@end
