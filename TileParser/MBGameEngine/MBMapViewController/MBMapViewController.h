//
//  MBMapViewController.h
//  TileParser
//
//  Created by Moshe Berman on 8/17/12.
//
//

#import <UIKit/UIKit.h>

#import "MBMapView.h"

#import "MBMapData.h"

@interface MBMapViewController : UIViewController <MBMapData>

@property (nonatomic, strong) MBMapView *mapView;

- (id)initWithMapName:(NSString *)name;

@end
