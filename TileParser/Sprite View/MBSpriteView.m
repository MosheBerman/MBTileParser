//
//  MBSpriteView.m
//  TileParser
//
//  Created by Andrew Dudney on 8/16/12.
//
//

#import "MBSpriteView.h"

@implementation MBSpriteView

- (id)initWithSpriteName:(NSString *)name{

    self = [super init];
    
    if(self){
        
        _animations = [self animationsDictionaryFromFile:name];
        
        NSString *randomKey = [[_animations allKeys] objectAtIndex:0];
        CGSize imageSize = [[[_animations objectForKey:randomKey] objectAtIndex:0] size];
        
        [self setActiveAnimation:randomKey];
        
        self.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        self.contentMode = UIViewContentModeTopLeft;
        
    }
    
    return self;
}

#pragma mark - Start/Stop Animation

//
//  This method was written by Andrew Dudney on 8/16/12 and moved
//  into the MBSpriteView class by Moshe Berman on 9/7/12.
//

- (NSDictionary *)animationsDictionaryFromFile:(NSString *)name{
	
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"plist"];
	NSError *error = nil;
    
	NSDictionary *serialization = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfURL:url] options:NSPropertyListImmutable format:NULL error:&error];
    
	if (error) {
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
    
	for (NSString *frameName in [[serialization objectForKey:@"frames"] allKeys]) {
        
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
        
		while ([animationValues count] < frameNumber) {
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

- (void) setActiveAnimation:(NSString *)direction{
	self.animationImages = [[self animations] objectForKey:direction];
	self.image = self.animationImages[0];
}



@end
