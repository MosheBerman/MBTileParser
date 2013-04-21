//
//  MBTileParser.m
//  TileParser
//
//  Created by Moshe on 7/30/12.
//
//

#import "MBTileParser.h"

#import "MBTileSet.h"

#import "MBMapObjectGroup.h"

@interface MBTileParser () <NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, copy) NSString *workingElement;
@property (nonatomic) NSNumber *workingTileIdentifier;
@end

@implementation MBTileParser

- (id)initWithMapName:(NSString *)map{
    self = [super init];
    
    if (self) {
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:map ofType:@"tmx"];
        
        if (fullPath == nil) {
            NSLog(@"Failed to load map at path: %@", fullPath);
            return nil;
        }
        
        NSURL *URL = [NSURL fileURLWithPath:fullPath];
        
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
        _mapDictionary = [@{} mutableCopy];
        _parser.delegate = self;
        _workingElement = nil;
        _workingTileIdentifier = nil;
    }
    
    return self;
}

/*  Start parsing */

- (void)start{
    [self.parser parse];
}

/* NSXMLParser Delegate methods */

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
    NSMutableArray *tilesets = [NSMutableArray array];
    [self.mapDictionary setObject:tilesets forKey:@"tilesets"];
    
    NSMutableArray *layers = [NSMutableArray array];
    [self.mapDictionary setObject:layers forKey:@"layers"];
    
    NSMutableArray *mapObjects = [NSMutableArray array];
    [self.mapDictionary setObject:mapObjects forKey:@"objectGroups"];
    
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
        
        NSNumber *tileIdentifier = [NSNumber numberWithInteger:[[attributeDict objectForKey:@"id"] integerValue]];
        
        self.workingTileIdentifier = tileIdentifier;
        
        MBTileSet *tileset = [[self.mapDictionary objectForKey:@"tilesets"] lastObject];
        [tileset.tileProperties setObject:[@{} mutableCopy] forKey:tileIdentifier];
    }
    
    //
    //  Add object groups where relevant
    //
    
    if ([[self workingElement] isEqualToString:@"objectgroup"]) {
        
        NSMutableArray *objectGroups = [self.mapDictionary objectForKey:@"objectGroups"];
        
        MBMapObjectGroup *group = [[MBMapObjectGroup alloc] init];
        
        //
        //  Configure the group
        //
        
        NSInteger width = [[attributeDict objectForKey:@"width"] integerValue];
        NSInteger height = [[attributeDict objectForKey:@"height"] integerValue];
        
        [group setWidth: width];
        [group setHeight: height];
        
        [group setName: [attributeDict objectForKey:@"name"]];
        
        //
        //  Store it
        //
        
        [objectGroups addObject:group];

    }
    
    if ([self.workingElement isEqualToString:@"object"]) {
        MBTileMapObject *object = [[MBTileMapObject alloc] init];
        object.x = [[attributeDict objectForKey:@"x"] integerValue];
        object.y = [[attributeDict objectForKey:@"y"] integerValue];
        
        object.width = [[attributeDict objectForKey:@"width"] integerValue];
        object.height = [[attributeDict objectForKey:@"height"] integerValue];
        
        NSMutableArray *objectGroups = [self.mapDictionary objectForKey:@"objectGroups"];
        MBMapObjectGroup *group = [objectGroups lastObject];
        [group.mapObjects addObject:object];
    }
    
    //
    //  Pull out properties from the XML and assign them
    //
    
    if ([self.workingElement isEqualToString:@"property"]) {
        
        if (!self.workingTileIdentifier) {
            
            NSMutableArray *objectGroups = [self.mapDictionary objectForKey:@"objectGroups"];
            
            MBMapObjectGroup *workingGroup = [objectGroups lastObject];
            
            MBTileMapObject *mapObject = [workingGroup.mapObjects lastObject];
            
            [mapObject.properties addEntriesFromDictionary:attributeDict];
            
        }else{
            
            MBTileSet *tileset = [[self.mapDictionary objectForKey:@"tilesets"] lastObject];
            NSMutableDictionary *tileProperties = [tileset.tileProperties objectForKey:self.workingTileIdentifier];
            [tileProperties addEntriesFromDictionary:attributeDict];
        }
        
    }
    
    //
    //  Add the image data to the last tileset, since it's part of it
    //
    
    if ([self.workingElement isEqualToString:@"image"]) {
        
        MBTileSet *lastTileset = [[self.mapDictionary objectForKey:@"tilesets"] lastObject];
        
        // Load the properties of the image from the XML into the tileset
        
        NSString *source = [attributeDict objectForKey:@"source"];
        NSInteger width = [[attributeDict objectForKey:@"width"] integerValue];
        NSInteger height = [[attributeDict objectForKey:@"height"] integerValue];
        
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
    
    if ([self.workingElement isEqualToString:@"data"]) {
        
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
    
    if ([elementName isEqualToString:@"tile"]) {
        self.workingTileIdentifier = nil;
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
        
        MBMap *map = [[MBMap alloc] init];
        
        map.layers = [self.mapDictionary objectForKey:@"layers"];
        
        map.tilesets = [self.mapDictionary objectForKey:@"tilesets"];
        
        NSMutableArray *objectGroups = [self.mapDictionary objectForKey:@"objectGroups"];
        
        for (MBMapObjectGroup *objectGroup in objectGroups) {
            [map.objectGroups setObject:objectGroup forKey:objectGroup.name];
        }
        
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstgid" ascending:YES];
        [map.tilesets sortUsingDescriptors:@[descriptor]];
         
        self.completionHandler(map);
    }
}


@end
