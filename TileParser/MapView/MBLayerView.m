//
//  MBLayerView.m
//  TileParser
//
//  Created by Moshe Berman on 8/14/12.
//
//

#import "MBLayerView.h"

#import "MBMapView.h"

@interface MBLayerView ()

@end

@implementation MBLayerView

- (id)initWithLayerData:(NSDictionary *)data tilesets:(NSArray *)tilesets imageCache:(NSArray *)cache{
    
    //
    //  Read this out form the layer data. We only allow one tile size per layer,
    //  so if different tilesets have different tilesizes you're out of luck. We could
    //  try to fix this by finding the largest size, but it could adversely affect the
    //  smaller ones, so it makes no sense. Instead, grab the first tileset and use its
    //  tile dimensions.
    //
    
    NSInteger heightOfATile = [[[tilesets objectAtIndex:0] objectForKey:@"tileheight"] integerValue];
    NSInteger widthOfATile = [[[tilesets objectAtIndex:0] objectForKey:@"tileheight"] integerValue];
    
    //
    //  The number of tiles comes from the layer
    //
    
    NSInteger heightInTiles = [[data objectForKey:@"height"] integerValue];
    NSInteger widthInTiles = [[data objectForKey:@"height"] integerValue];
    
    NSInteger height = heightInTiles * heightOfATile;
    NSInteger width = widthInTiles * widthOfATile;
    
    //
    //  Since we're placing these in a scroll view, the origin should be zero.
    //  We shrink the UIScrollView to fit the largest one. TMX layers
    //  are all the same size.
    //
    
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    
    if (self) {
        
        _heightInTiles = heightInTiles;
        _widthInTiles = widthInTiles;
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
