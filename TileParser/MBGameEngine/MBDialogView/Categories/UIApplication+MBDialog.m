//
//  UIApplication+MBDialog.m
//  TileParser
//
//  Created by Moshe Berman on 11/1/12.
//
//

#import "UIApplication+MBDialog.h"

@implementation UIApplication (MBDialog)

+ (UIView *) rootView{
    return [[[[self sharedApplication] keyWindow] rootViewController] view];
}

@end
