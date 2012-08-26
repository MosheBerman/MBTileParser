//
//  MBMapViewController.h
//  TileParser
//
//  Created by Moshe Berman on 8/17/12.
//
//

#import <UIKit/UIKit.h>

#import "MBMapView.h"

@interface MBMapViewController : UIViewController

@property (nonatomic, strong) MBMapView *mapView;

- (id)initMapName:(NSString *)name;


@end
