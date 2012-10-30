//
//  NSString+MBDialogString.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "NSString+MBDialogString.h"

@implementation NSString (MBDialogString)

//
//  Calculates the substring that fits in a frame
//

- (NSString *) substringThatFitsFrame:(CGRect)frame withFont:(UIFont *)font{
    
    NSString *truncatedString = self;
    
    CGSize clippingSize = CGSizeMake(frame.size.width, CGFLOAT_MAX);
    
    CGSize size = [truncatedString sizeWithFont:font constrainedToSize:clippingSize lineBreakMode:NSLineBreakByClipping];

    
    NSMutableArray *components = [[truncatedString componentsSeparatedByString:@" "] mutableCopy];
    
    while (frame.size.width <= size.width || frame.size.height <= size.height) {
        
        [components removeLastObject];
        
        truncatedString = [components componentsJoinedByString:@" "];
        
        size = [truncatedString sizeWithFont:font constrainedToSize:clippingSize lineBreakMode:NSLineBreakByClipping];
        
    }

    return truncatedString;
}

//
//  Returns an array of dialog string that fits in a given frame for a given font
//

- (NSArray *)dialogArrayForFrame:(CGRect)frame andFont:(UIFont*)font{
    
    if (frame.size.height <= 0 || frame.size.width <= 0) {
//        NSLog(@"Zero or negative frame dimensions, returning. Frame is %@", NSStringFromCGRect(frame));
        return nil;
    }
    
    NSMutableArray *newDialog = [@[] mutableCopy];
    
    NSMutableString *textToCache = [self mutableCopy];
    
    while (![textToCache isEqualToString:@""]) {
        NSString *substringThatFits = [textToCache substringThatFitsFrame:frame withFont:font];
        [newDialog addObject:substringThatFits];
        textToCache = [[textToCache stringByReplacingOccurrencesOfString:substringThatFits withString:@""] mutableCopy];
    }
    
    return newDialog;

}

@end
