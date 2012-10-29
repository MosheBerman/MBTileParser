//
//  NSString+MBDialogString.h
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (MBDialogString)

//
//  Returns an array of dialog string that fits in a given frame for a given font
//

- (NSArray *)dialogArrayForFrame:(CGRect)frame andFont:(UIFont*)font;

@end
