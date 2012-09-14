//
//  MBControllerViewController.h
//  TileParser
//
//  Created by Moshe Berman on 8/26/12.
//
//

#import <UIKit/UIKit.h>

#import "MBControllerToggling.h"

@interface MBControllerViewController : UIViewController

//
//  Add/Remove Observers for controller events
//

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

@end
