//
//  MBSpriteView.m
//  TileParser
//
//  Created by Andrew Dudney on 8/16/12.
//
//

#import "MBSpriteView.h"

@interface MBSpriteView()

@property(nonatomic, strong) NSDictionary *animations;

@end

@implementation MBSpriteView

- (id)initWithAnimations:(NSDictionary *)animations{
	self = [super init];
	if(self){
		self.animations = animations;
		self.animationDuration = 1.0/3.0;
	}
	return self;
}

- (void)beginAnimation:(NSString *)animationID{
	self.animationImages = [self.animations objectForKey:animationID];
	[self startAnimating];
}

- (void)stopAnimation{
	[self stopAnimating];
	self.image = self.animationImages[0];
	self.animationImages = nil;
}

@end
