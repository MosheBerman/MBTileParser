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

- (void)moveInRandomDirection{
    
    MBSpriteMovementDirection direction = arc4random()%4;
    
    __weak MBSelfMovingSpriteView *weakSelf = self;
    
    MBMovementCompletionHandler completion = ^{
        
        __strong MBSelfMovingSpriteView *strongSelf = weakSelf;
        
        float delay = arc4random()%3;
        
        [strongSelf performSelector:@selector(moveInRandomDirection) withObject:nil afterDelay:delay];
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
