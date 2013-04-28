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
    
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    [self setState:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
}

- (void)saveStateToURL:(NSURL *)fileURL
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self state]];
    [data writeToURL:fileURL atomically:NO];
}

- (void)loadFreshState
{
    
    [self setState:[MBGameState new]];
}

@end
