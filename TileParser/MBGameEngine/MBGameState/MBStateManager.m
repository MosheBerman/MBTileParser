//
//  MBStateManager.m
//  TileParser
//
//  Created by Moshe Berman on 4/21/13.
//
//

#import "MBStateManager.h"

@implementation MBStateManager

+ (MBStateManager *)sharedManager
{
 
    static MBStateManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [MBStateManager new];
    });
    return manager;
}

- (void)loadStateFromURL:(NSURL *)fileURL
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfURL:fileURL];

    [self setState:[MBGameState gameStateFromDictionary:dictionary]];
}

- (void)saveStateToURL:(NSURL *)fileURL
{
    NSDictionary *dictionary = [[self state] asDictionary];
    [dictionary writeToURL:fileURL atomically:NO];
}

- (void)loadFreshState
{
    [self setState:[MBGameState new]];
}

@end
