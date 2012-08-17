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
		
        _animations = animations;
		self.animationDuration = 1.0/3.0;
        
        NSString *randomKey = [[animations allKeys] objectAtIndex:0];
        CGSize imageSize = [[[animations objectForKey:randomKey] objectAtIndex:0] size];
        
        self.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        self.contentMode = UIViewContentModeTopLeft;
        
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

- (void) setDirection:(NSString *)direction{
	self.animationImages = [self.animations objectForKey:direction];
	self.image = self.animationImages[0];
}

@end
