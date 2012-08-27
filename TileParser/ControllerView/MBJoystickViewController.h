//
//  MBJoystickViewController.h
//  TileParser
//
//  Created by Moshe Berman on 8/27/12.
//
//

#import "MBControllerViewController.h"

@interface MBJoystickViewController : MBControllerViewController

@property (nonatomic) BOOL isAnalog;
@property (nonatomic) CGFloat radius;
@property (nonatomic) NSInteger numberOfDirections;

@end
