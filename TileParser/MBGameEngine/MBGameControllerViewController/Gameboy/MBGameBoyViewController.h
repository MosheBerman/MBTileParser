//
//  MBGameBoyViewController.h
//  TileParser
//
//  Created by Moshe Berman on 8/27/12.
//
//

#import "MBControllerViewController.h"

#import "MBJoystickView.h"

#import "MBControllerButton.h"

@interface MBGameBoyViewController : MBControllerViewController <MBControllerToggling>

@property (nonatomic, strong) MBJoystickView *joystick;

@property (nonatomic, strong) MBControllerButton *buttonA;
@property (nonatomic, strong) MBControllerButton *buttonB;
@property (nonatomic, strong) MBControllerButton *buttonStart;
@property (nonatomic, strong) MBControllerButton *buttonSelect;

@end
