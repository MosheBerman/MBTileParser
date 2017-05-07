//
//  MBGameController.h
//  TileParser
//
//  Created by Moshe Berman on 5/7/17.
//
//

@import GameController;
#import "MBControllerInput.h"

@interface MBGameController : NSObject <MBControllerInput>

-(void)pickBestController;

@end
