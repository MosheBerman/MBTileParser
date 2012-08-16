//
//  MBTileParser.m
//  TileParser
//
//  Created by Moshe on 7/30/12.
//
//

#import "MBTileParser.h"

#import "MBTileSet.h"

@interface MBTileParser () <NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, copy) NSString *workingElement;
@property (nonatomic) NSInteger workingTileIdentifier;
@end

@implementation MBTileParser


- (id)initWithMapName:(NSString *)map{
    self = [super init];
    
    if (self) {
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:map ofType:@"tmx"];
        
        NSURL *URL = [NSURL fileURLWithPath:fullPath];
        
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
        _mapDictionary = [NSMutableDictionary dictionary];
        _parser.delegate = self;
        _workingElement = nil;
        _workingTileIdentifier = -1;
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
        
        MBTileSet *tileset = [[MBTileSet alloc] initWithDictionary:attributeDict];
        
        [[self.mapDictionary objectForKey:@"tilesets"] addObject:tileset];
    }
    
    //
    //  Adjust the working tile where appropriate
    //
    
    if ([self.workingElement isEqualToString:@"tile"]) {
        
        NSInteger tileIdentifier = [[attributeDict objectForKey:@"id"] integerValue];
        
        self.workingTileIdentifier = tileIdentifier;
    }
    
    //
    //  Add the image data to the last tileset, since it's part of it
    //
    
    if ([self.workingElement isEqualToString:@"image"]) {
        
        MBTileSet *lastTileset = [[self.mapDictionary objectForKey:@"tilesets"] lastObject];
        
        //
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        // Load the properties of the image from the XML into the tileset
        
        
        NSString *source = [attributeDict objectForKey:@"source"];
        NSInteger width = [[formatter numberFromString:[attributeDict objectForKey:@"width"]] integerValue];
        NSInteger height = [[formatter numberFromString:[attributeDict objectForKey:@"height"]] integerValue];
        
        [lastTileset setSource:source];
        [lastTileset setWidth:width];
        [lastTileset setHeight:height];
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
        
        [lastLayer setObject:[NSMutableString string] forKey:@"tempdata"];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //
    //  When we find tile id data, we need to add it to the existing data.
    //
    
    if ([self.workingElement isEqualToString:@"data"]) {
        
        NSMutableDictionary *lastLayer =  [[self.mapDictionary objectForKey:@"layers"] lastObject];
        
        NSString *mapData = [lastLayer objectForKey:@"tempdata"];
        
        NSString *stringWithoutNewlines = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *newMapData = [NSString stringWithFormat:@"%@%@", mapData, stringWithoutNewlines];
        
        [lastLayer setObject:newMapData forKey:@"tempdata"];
    }
    

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    //
    //  We're done reading properties for 
    //
    
    if ([self.workingElement isEqualToString:@"tile"]) {
        self.workingTileIdentifier = -1;
    }
    
    //
    //  TODO: If the tile id information is encoded as base64 data, decode it here.
    //  Use cocos2d base64 lib here? Use zlib?
    //
    
    
    
    //
    //  Encode the strings as arrays.
    //
    
    if ([elementName isEqualToString:@"layer"]) {
        
        NSMutableDictionary *lastLayer =  [[self.mapDictionary objectForKey:@"layers"] lastObject];
        
        NSString *tileIdentifiersAsString = [lastLayer objectForKey:@"tempdata"];
        
        NSArray *tileIdentifiersAsArray = [tileIdentifiersAsString componentsSeparatedByString:@","];
        
        [lastLayer setObject:tileIdentifiersAsArray forKey:@"data"];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    //NSLog(@"Error Parsing: %@", [parseError description]);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    if (self.completionHandler) {
        self.completionHandler();
    }
}


@end
