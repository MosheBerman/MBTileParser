//
//  MBSelfMovingSpriteView.m
//  TileParser
//
//  Created by Moshe Berman on 9/7/12.
//
//

#import "MBSelfMovingSpriteView.h"

@interface MBSelfMovingSpriteView ()

@end

@implementation MBSelfMovingSpriteView

- (void) moveInRandomDirection{
    
    MBSpriteMovementDirection direction = arc4random()%4;
    
    float delay = (arc4random()%6);
    
    MBMovementCompletionHandler completion = ^{
        [self performSelector:@selector(moveInRandomDirection) withObject:nil afterDelay:delay];
    };
    
    if (direction == 0) {
        [self moveUpWithCompletion:completion];
    }else if(direction == 1){
        [self moveDownWithCompletion:completion];
    }else if(direction == 2){
        [self moveLeftWithCompletion:completion];
    }else if(direction == 3){
        [self moveRightWithCompletion:completion];
    }
}

@end
