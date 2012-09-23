//
//  MBMapViewController.m
//  TileParser
//
//  Created by Moshe Berman on 8/17/12.
//
//

#import "MBMapViewController.h"

#import "MBTileParser.h"

#import "MBTileSet.h"

#import "MBTileMapObject.h"

#import "UIImage+TileData.h"

@interface MBMapViewController ()

@property (nonatomic, strong) MBTileParser *parser;
@property (nonatomic, strong) MBMap *map;

@end

@implementation MBMapViewController

- (id)initWithMapName:(NSString *)name{
    self = [super init];
    if (self) {
        
        _mapView = [[MBMapView alloc] init];
        
        [self loadMap:name];
    }
    return self;
}

- (void)loadView{
    [self setView:self.mapView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    CGRect frame = [[[self view] superview] frame];
    [[self view] setFrame:frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loading a Game Map

- (void) loadMap:(NSString *)mapName{
    
    [self setParser: [[MBTileParser alloc] initWithMapName:mapName]];
    
    //
    //  Keep a weak reference to self to
    //  avoid retain cycle
    //
    
    __weak MBMapViewController *weakSelf = self;
    
    MBTileParserCompletionBlock block = ^(MBMap *map){
        
        __strong MBMapViewController *strongSelf = weakSelf;
        
        [[strongSelf mapView] loadMap:map];
        
        [strongSelf setMap:map];
        
    };
    
    [_parser setCompletionHandler:block];
    
    [_parser start];
}

#pragma mark - MBMapData Protocol 

- (NSDictionary *)propertiesForObjectInGroupNamed:(NSString *) atPoint:(CGPoint)points{
    
}

- (NSDictionary *)propertiesForTileInLayer:(NSString *)layerName atCoordinates:(CGPoint)coordinates{
    
}


- (CGSize)tileSizeInPoints{
    MBTileSet *tileSet = [[self map] tilesets][0];
    return [tileSet tileSize];
}

@end