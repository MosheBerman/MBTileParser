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
@synthesize parser;
@synthesize workingElement;
@synthesize mapDictionary;
@synthesize isReady;

- (id)initWithURL:(NSURL *)url{
    self = [super init];
    
    if (self) {
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        self.mapDictionary = [NSMutableDictionary dictionary];
        self.isReady = NO;
        parser.delegate = self;
    }
    
    return self;
}

/*  Start parsing */

- (void) start{
    [self.parser parse];
}

/* NSXMLParser */

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
    

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
}


@end
