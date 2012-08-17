//
//  MBSpriteParser.m
//  TileParser
//
//  Created by Andrew Dudney on 8/16/12.
//
//

#import "MBSpriteParser.h"

#import "MBSpriteView.h"

@implementation MBSpriteParser

+ (MBSpriteView *)spriteViewWithSpriteName:(NSString *)name{
	NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"plist"];
	NSError *error = nil;
    
	NSDictionary *serialization = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfURL:url] options:NSPropertyListImmutable format:NULL error:&error];
    
	if(error){
		NSLog(@"Error: %@", error);
	}
	
	NSDictionary *metadata = [serialization objectForKey:@"metadata"];
	NSString *imageName = [metadata objectForKey:@"realTextureFileName"];
	UIImage *sourceImage = [UIImage imageNamed:imageName];
	
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
        
	
        
//		while([animationValues count] < frameNumber){
//			[animationValues addObject:[NSNull null]];
//		}
		
		CGImageRef cutImage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectFromString([frameMetadata objectForKey:@"frame"]));
		UIImage *image = [UIImage imageWithCGImage:cutImage];
		
		[animationValues addObject:image];
	}
    
    //
    //  Automatically size the sprite
    //
	
	MBSpriteView *sprite = [[MBSpriteView alloc] initWithAnimations:animations];
    
    NSString *randomKey = [[animations allKeys] objectAtIndex:0];
    
    CGSize imageSize = [[[animations objectForKey:randomKey] objectAtIndex:0] size];
    
    sprite.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
	
	return sprite;
}

@end
