//
//  MBStateManager.h
//  TileParser
//
//  Created by Moshe Berman on 4/21/13.
//
//

#import <Foundation/Foundation.h>

#import "MBGameState.h"

@interface MBStateManager : NSObject

@property (nonatomic, strong) MBGameState *state;

#pragma mark - Singleton Access

+ (MBStateManager *)sharedManager;

#pragma mark - Loader

- (void)loadStateFromURL:(NSURL *)fileURL;
- (void)saveStateToURL:(NSURL *)fileURL;

- (void)loadFreshState;

@end