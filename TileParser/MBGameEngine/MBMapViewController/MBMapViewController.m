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

#pragma mark - Sprite Movement Delegate 

- (CGSize)tileSizeInPointsForSprite:(MBSpriteView *)sprite{
    MBTileSet *tileSet = [[self map] tilesets][0];
    return [tileSet tileSize];
}

- (BOOL)sprite:(MBSpriteView *)sprite canMoveToCoordinates:(CGPoint)coordinates{
 
    
    
    if (coordinates.x < 0 || coordinates.y < 0)  {
        return NO;
    }
    
    CGSize tileSize = [self tileSizeInPointsForSprite:sprite];
    
    //  Get a rect covering the target tile
    CGRect targetLocation = CGRectMake(coordinates.x * tileSize.width, coordinates.y * tileSize.height, tileSize.width,  tileSize.height);
    
    //Check for other sprites
    for (MBSpriteView *aSprite in [[[self mapView] sprites] allValues]) {
        if (CGRectIntersectsRect(aSprite.frame, targetLocation) && aSprite != sprite) {
            return NO;
        }
    }
    
    UIImage *destinationTile = [[self mapView] tileAtCoordinates:coordinates inLayerNamed:@"Meta"];
    
    NSDictionary *tileProperties = [destinationTile tileData];
    
    if ([tileProperties[@"name"] isEqualToString:@"solid"]) {
        return NO;
    }
    
    if ([tileProperties[@"name"] isEqualToString:@"water"]) {
        return NO;
    }
    
    return YES;
}

- (void)sprite:(MBSpriteView *)sprite interactWithTileAtCoordinates:(CGPoint)coordinates{
    
    if (coordinates.x < 0 || coordinates.y < 0)  {
        return;
    }
    
    CGSize tileSize = [self tileSizeInPointsForSprite:sprite];
    
    //  Get a rect covering the target tile
    //CGRect targetLocation = CGRectMake(coordinates.x * tileSize.width, coordinates.y * tileSize.height, (coordinates.x+1) * tileSize.width, (coordinates.y+1) * tileSize.height);

    for (MBTileMapObject *object in [[[self map] objectGroups] objectForKey:@"Connections"]) {
        
        
        
    }
}

@end