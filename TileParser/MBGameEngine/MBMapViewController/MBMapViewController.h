//
//  MBMapViewController.h
//  TileParser
//
//  Created by Moshe Berman on 8/17/12.
//
//

#import <UIKit/UIKit.h>

#import "MBMapView.h"

#import "MBMapMetadata.h"

#import "MBMapObjectGroup.h"

@interface MBMapViewController : UIViewController <MBMapMetadata>

@property (nonatomic, strong) MBMapView *mapView;

- (id)initWithMapName:(NSString *)name;

- (void) loadMap:(NSString *)mapName;
@end
