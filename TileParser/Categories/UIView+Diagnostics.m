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
            [self displayBorderOfColor:color onSubviewsOfView:subview];
        }else{
            subview.layer.borderColor = color.CGColor;
            subview.layer.borderWidth = 1.0f;
        }
    }
}

@end
