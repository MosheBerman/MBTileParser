//
//  NSString+MBDialogString.h
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (MBDialogString)

- (NSString *)reducedToFrame:(CGRect)frame withFont:(UIFont *)font inSize:(CGSize)size;

@end
