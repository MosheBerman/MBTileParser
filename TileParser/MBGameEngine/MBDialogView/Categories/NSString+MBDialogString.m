//
//  NSString+MBDialogString.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "NSString+MBDialogString.h"

@implementation NSString (MBDialogString)

- (NSString *)reducedToFrame:(CGRect)frame withFont:(UIFont *)font inSize:(CGSize)size{
     
     if ([self sizeWithFont:font].width <= frame.size.width || [self length] == 1) {
         return self;
     }
     NSMutableString *string = [NSMutableString string];
     for (NSInteger i = 0; i < [self length]; i++) {
         [string appendString:[self substringWithRange:NSMakeRange(i, 1)]];
         
         CGSize sizeThatFitsString = [string sizeWithFont:font constrainedToSize:size];
         if (sizeThatFitsString.width > frame.size.width || sizeThatFitsString.height) {
             [string deleteCharactersInRange:NSMakeRange(i, 1)];
             break;
         }
     }
     
     return string;
 }

@end
