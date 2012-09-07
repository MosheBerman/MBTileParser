//
//  MBSpriteView.m
//  TileParser
//
//  Created by Andrew Dudney on 8/16/12.
//
//

#import "MBSpriteView.h"

#import "MBControllerEvent.h"

#import "MBJoystickView.h"

#define kMovementDuration 0.4

@implementation MBSpriteView

- (id) initWithSpriteName:(NSString *)name{

    self = [super init];
    
    if(self){
        
        _animations = [self animationsDictionaryFromFile:name];
        
		self.animationDuration = 1.0 * kMovementDuration;
        
        NSString *randomKey = [[_animations allKeys] objectAtIndex:0];
        CGSize imageSize = [[[_animations objectForKey:randomKey] objectAtIndex:0] size];
        
        [self setActiveAnimation:randomKey];
        
        self.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        self.contentMode = UIViewContentModeTopLeft;
        
        _isMoving = NO;
    }
    
    return self;
}

#pragma mark - Start/Stop Animation

- (NSDictionary *)animationsDictionaryFromFile:(NSString *)name{
	
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"plist"];
	NSError *error = nil;
    
	NSDictionary *serialization = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfURL:url] options:NSPropertyListImmutable format:NULL error:&error];
    
	if(error){
		NSLog(@"Can't load plist. Returning nil.\nError: %@", error);
        return nil;
	}
	
	NSDictionary *metadata = [serialization objectForKey:@"metadata"];
	NSString *imageName = [metadata objectForKey:@"textureFileName"];
	
    UIImage *sourceImage = [UIImage imageNamed:imageName];
	
    if (!sourceImage) {
        NSLog(@"Can't load image, returning nil");
        return nil;
    }
    
	NSMutableDictionary *animations = [NSMutableDictionary dictionary];
    
	for(NSString *frameName in [[serialization objectForKey:@"frames"] allKeys]){
        
		NSDictionary *frameMetadata = [[serialization objectForKey:@"frames"] objectForKey:frameName];
		NSArray *frameNameSeparated = [frameName componentsSeparatedByString:@"-"];
		
		NSString *animationKey = frameNameSeparated[1];
		
		NSMutableArray *animationValues = [animations objectForKey:animationKey];
        
		if(!animationValues){
			animationValues = [NSMutableArray array];
			[animations setObject:animationValues forKey:animationKey];
		}
        
        //
        //  Deal with frames being out of order in the plist
        //
        
        NSInteger frameNumber = [frameNameSeparated[2] integerValue];
        
		while([animationValues count] < frameNumber){
			[animationValues addObject:[NSNull null]];
		}
		
		CGImageRef cutImage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectFromString([frameMetadata objectForKey:@"frame"]));
		UIImage *image = [UIImage imageWithCGImage:cutImage];
		
		[animationValues replaceObjectAtIndex:frameNumber-1 withObject:image];
	}
	
    return animations;
}

#pragma mark - Animation Playback Control

- (void)beginAnimationWithKey:(NSString *)animationID{
	self.animationImages = [self.animations objectForKey:animationID];
	[self startAnimating];
}

- (void)stopAnimation{
	[self stopAnimating];
	self.image = self.animationImages[0];
	self.animationImages = nil;
}


#pragma mark - Movement Methods

- (void) setActiveAnimation:(NSString *)direction{
	self.animationImages = [[self animations] objectForKey:direction];
	self.image = self.animationImages[0];
}

//  Move in a direction
- (void) moveInDirection:(MBSpriteMovementDirection)direction distanceInTiles:(NSInteger)distanceInTiles withCompletion:(void (^)())completion{
    
    CGRect oldFrame = [self frame];
    CGSize tileDimensions = [[self movementDelegate] tileSizeInPoints];
    
    CGPoint tileCoordinates = CGPointMake(oldFrame.origin.x/tileDimensions.width, oldFrame.origin.y/tileDimensions.height);
    
    //  Calculate the new position
    if (direction == MBSpriteMovementDirectionHorizontal) {
        oldFrame.origin.x += (tileDimensions.width * distanceInTiles);
        tileCoordinates.x += distanceInTiles;
    }else{
        oldFrame.origin.y += (tileDimensions.height * distanceInTiles);
        tileCoordinates.y += distanceInTiles;
    }
    
    if (![[self movementDelegate] tileIsOpenAtCoordinates:tileCoordinates forSprite:self]) {
        [self resetMovementState];
        return;
    }
    
    [self startMoving];
    
    [UIView animateWithDuration:distanceInTiles*kMovementDuration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        [self setFrame:oldFrame];
    }
                     completion:^(BOOL finished) {
                         //  Perform whatever the callback warrants
                         if(completion){
                             completion();
                         }
                         [self resetMovementState];
                     }];
}

- (void) startMoving{
    [self setIsMoving:YES];
    [self startAnimating];
}

- (void) resetMovementState{
    [self setIsMoving:NO];
    [self stopAnimation];
}

#pragma mark - Single Tile Movement

- (void) moveUpWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"up"];
    [self moveInDirection:MBSpriteMovementDirectionVertical distanceInTiles:-1 withCompletion:completion];
}

- (void) moveDownWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"down"];
    [self moveInDirection:MBSpriteMovementDirectionVertical distanceInTiles:1 withCompletion:completion];
}

- (void) moveLeftWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"left"];
    [self moveInDirection:MBSpriteMovementDirectionHorizontal distanceInTiles:-1 withCompletion:completion];
}

- (void) moveRightWithCompletion:(void (^)()) completion{
    [self beginAnimationWithKey:@"right"];
    [self moveInDirection:MBSpriteMovementDirectionHorizontal distanceInTiles:1 withCompletion:completion];
}

#pragma mark - Game Controller Support

- (void)gameController:(MBControllerViewController *)controller buttonsPressedWithSender:(id)sender{
    
}

- (void)gameController:(MBControllerViewController *)controller buttonsReleasedWithSender:(id)sender{
    
}

- (void)gameController:(MBControllerViewController *)controller joystickValueChangedWithSender:(id)value{
    
    if (_isMoving) {
        return;
    }
    
    MBJoystickView *joystick = value;
    
    CGPoint velocity = [joystick velocity];
    
    if (velocity.x == 1) {
        
        [self setActiveAnimation:@"right"];
        [self moveRightWithCompletion:nil];
    }
    
    if(velocity.y == 1){

        [self setActiveAnimation:@"up"];
        [self moveUpWithCompletion:nil];
    }
    
    if (velocity.x == -1) {

        [self setActiveAnimation:@"left"];        
        [self moveLeftWithCompletion:nil];
    }
    
    if(velocity.y == -1){

        [self setActiveAnimation:@"down"];        
        [self moveDownWithCompletion:nil];
    }
}

@end
