//
//  UIView+diagnostics.m
//  TileParser
//
//  Created by Moshe Berman on 9/7/12.
//
//

#import "UIView+Diagnostics.h"

@implementation UIView (Diagnostics)

- (void)displayBorderOfColor:(UIColor *)color onSubviewsOfView:(UIView *)aView{
    for (UIView *subview in aView.subviews) {
        if ([[subview subviews] count]) {
            [[subview layer] setBorderColor:[color CGColor]];
            [[subview layer] setBorderWidth:1.0f];
            [self displayBorderOfColor:color onSubviewsOfView:subview];
        }else{
            [[subview layer] setBorderColor:[color CGColor]];
            [[subview layer] setBorderWidth:1.0f];
        }
    }
}

@end
