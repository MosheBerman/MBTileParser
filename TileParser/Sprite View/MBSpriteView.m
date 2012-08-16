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

- (id)initWithFrame:(CGRect)frame spriteSheetName:(NSString *)spriteSheetName{
	self = [super initWithFrame:frame];
	if(self){
		NSURL *url = [[NSBundle mainBundle] URLForResource:spriteSheetName withExtension:@"plist"];
		NSError *error = nil;
		NSPropertyListSerialization *serialization = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfURL:url] options:NSPropertyListImmutable format:NULL error:&error];
		if(error){
			NSLog(@"Error: %@", error);
		}
		
		
		
		//self.animations = animations;
	}
	return self;
}

- (void)beginAnimation:(NSString *)animationID{
	self.animationImages = [self.animations objectForKey:animationID];
}

- (void)stopAnimation{
	self.image = self.animationImages[0];
	self.animationImages = nil;
}

@end
