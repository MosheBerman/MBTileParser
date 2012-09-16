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

- (void)gameController:(MBControllerViewController *)controller buttonPressedWithSender:(id)sender;
- (void)gameController:(MBControllerViewController *)controller buttonReleasedWithSender:(id)sender;
- (void)gameController:(MBControllerViewController *)controller joystickValueChangedWithSender:(id)value;

@end
