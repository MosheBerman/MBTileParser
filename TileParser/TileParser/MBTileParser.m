//
//  MBTileParser.m
//  TileParser
//
//  Created by Moshe on 7/30/12.
//
//

#import "MBTileParser.h"

@interface MBTileParser () <NSXMLParserDelegate>
    @property (nonatomic, strong) NSXMLParser *parser;
    @property (nonatomic, copy) NSString *workingElement;
    @property (nonatomic, strong) NSMutableDictionary *mapDictionary;
@end

@implementation MBTileParser


- (id)initWithPath:(NSString *)path{
    self = [super init];
    
    if (self) {
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:path ofType:@"tmx"];
        
        NSURL *URL = [NSURL fileURLWithPath:fullPath];
        
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
        _mapDictionary = [NSMutableDictionary dictionary];
        _isReady = NO;
        _parser.delegate = self;
    }
    
    return self;
}

/*  Start parsing */

- (void) start{
    [self.parser parse];
}

/* NSXMLParser Delegate methods */

- (void)parserDidStartDocument:(NSXMLParser *)parser{

    NSMutableArray *tilesets = [NSMutableArray array];
    [self.mapDictionary setObject:tilesets forKey:@"tilesets"];
    
    NSMutableArray *layers = [NSMutableArray array];
    [self.mapDictionary setObject:layers forKey:@"layers"];
    
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    //
    //  Track which part of the tile parser we're working on
    //
    
    self.workingElement = [elementName lowercaseString];
    
    //
    //  Store tilesets
    //
    
    if ([self.workingElement isEqualToString:@"tileset"]) {
        
        NSMutableDictionary *tileset = [attributeDict mutableCopy];
        
        [[self.mapDictionary objectForKey:@"tilesets"] addObject:tileset];
    }
    
    //
    //  Add the image data to the last tileset, since it's part of it
    //
    
    if ([self.workingElement isEqualToString:@"image"]) {
        
        NSMutableDictionary *lastTileset = [[self.mapDictionary objectForKey:@"tilesets"] lastObject];
        
        [lastTileset addEntriesFromDictionary:attributeDict];
    }
    
    //
    //  If we have a layer, add it to the layers
    //
    
    if ([self.workingElement isEqualToString:@"layer"]) {
        
        NSMutableDictionary *layerInfo = [attributeDict mutableCopy];
    
        [[self.mapDictionary objectForKey:@"layers"] addObject:layerInfo];
    }
    
    //
    //  If we have layer data, store it in the last layer
    //

    if([self.workingElement isEqualToString:@"data"]){
        
        NSMutableDictionary *lastLayer =  [[self.mapDictionary objectForKey:@"layers"] lastObject];
        
        [lastLayer addEntriesFromDictionary:attributeDict];
        
        //
        //  Add a string for data
        //
        
        [lastLayer setObject:[NSMutableString string] forKey:@"data"];
        
    }

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //
    //  When we find tile id data, we need to add it to the existing data.
    //
    
    if ([self.workingElement isEqualToString:@"data"]) {
        
        NSMutableDictionary *lastLayer =  [[self.mapDictionary objectForKey:@"layers"] lastObject];
        
        NSString *mapData = [lastLayer objectForKey:@"data"];
        
        NSString *stringWithoutNewlines = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *newMapData = [NSString stringWithFormat:@"%@%@", mapData, stringWithoutNewlines];
        
        [lastLayer setObject:newMapData forKey:@"data"];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    //
    //  TODO: If the tile id information is encoded as base64 data, decode it here.
    //
    //  TODO: Encode the strings as arrays. 
    //
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Error Parsing: %@", [parseError description]);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"Map: %@", self.mapDictionary.description);
    self.isReady = YES;
}


@end
