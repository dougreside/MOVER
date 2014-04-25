//
//  InitialParser.m
//  NYPL
//
//  Created by Prakash Raj on 20/03/13.
//  Copyright (c) 2013 kiwitech. All rights reserved.
//

#import "InitialParser.h"
#import "JSON.h"
#import "Version.h"
#import "Play.h"
#import "Audio.h"
#import "DatabaseConnection.h"

#define kVersionXMLName @"version.xml"
#define kPlayJson @"playjsonfromat.txt"

@implementation InitialParser

int playid;

- (void)parseVersionXMLFile {
    
    _parsingType = kParsingVersion;
    _versions = [[NSMutableArray alloc]init];
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kVersionXMLName];
    [self startParsingFileAtPath:path];
}

- (void)parsePlayInfo {
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kPlayJson];
    NSString *jsonTxt = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
   
    if (jsonTxt) {
        NSLog(@"jsonTxt : %@",jsonTxt);
        NSError *error;
        SBJSON *json = [SBJSON new];
        NSDictionary *dict = [json objectWithString:jsonTxt error:&error];
        NSArray *arr = [dict objectForKey:@"Plays"];
        
        DatabaseConnection *dbConn = [DatabaseConnection sharedConnection];
        [dbConn removeAllItemsFromTable:@"PLAY"];
        
        for(NSDictionary *dict in arr) {
            Play *play = [[Play alloc]init];
            play.playId = [[dict objectForKey:@"playid"] integerValue];
            play.playTitle = [dict objectForKey:@"playname"];
            play.imageURL = [dict objectForKey:@"imageurl"];
            play.authorName = [dict objectForKey:@"author"];
            play.authorInfo = [dict objectForKey:@"authorinfo"];
            play.captionName = @"";            // not appear in json
            play.isFav = 1;                    // not appear in json.
            [dbConn addPlay:play];
        }
        NSLog(@"%@", arr);
    }
}

- (void)parseAudioFile:(NSString *)audiofile {
     _parsingType = kParsingAudio;
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:audiofile];
    [self startParsingFileAtPath:path];
}

- (void)startParsingFileAtPath:(NSString *)path {
    
    _currentElementValue = nil;
    _currentElementValue = [[NSMutableString alloc]init];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _parser = nil;
    _parser = [[NSXMLParser alloc]initWithData:data];
    _parser.delegate = self;
    [_parser parse];
}

#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [_currentElementValue appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict {
   
    if(_parsingType == kParsingVersion) {
        if([elementName isEqualToString:@"play"]) {
            NSLog(@"%@", attributeDict);
            playid = [[attributeDict objectForKey:@"id"] intValue];
        }
        
        if([elementName isEqualToString:@"version"]) {
            NSLog(@"%@", attributeDict);
            Version *v = [[Version alloc]init];
            v.playId = playid;
            v.versionName = [attributeDict objectForKey:@"name"];
            v.versionId = [[attributeDict objectForKey:@"id"] intValue];
            v.htmlFileName = [attributeDict objectForKey:@"htmlname"];
            v.audioName = [attributeDict objectForKey:@"audioname"];
            v.bookmark = 0;
            v.notes = @"";
            [_versions addObject:v];
        }
        
    } else if(_parsingType == kParsingAudio) {
        if([elementName isEqualToString:@"clip"]) {
             NSLog(@"Clip -> %@", attributeDict);
            _audio.clipId = [[attributeDict objectForKey:@"id"] intValue];
            _audio.fromTime = [[attributeDict objectForKey:@"from"] intValue];
            _audio.toTime = [[attributeDict objectForKey:@"to"] intValue];
            _audio.audioFileName = @"";
            [[DatabaseConnection sharedConnection]addAudio:_audio];
        }
    }
    _currentElementValue = [[NSMutableString alloc]init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"%@",elementName);
    _currentElementValue = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"------------- End ------------------");
    if(_parsingType == kParsingVersion) {
        DatabaseConnection *dbConn = [DatabaseConnection sharedConnection];
        [dbConn removeAllItemsFromTable:@"VERSION"];
        
        for (Version *ver in _versions) {
            [dbConn addVersion:ver];
            _audio = nil;
            _audio = [[Audio alloc]init];
            _audio.playId = ver.playId;
            _audio.versionId = ver.versionId;
            [self parseAudioFile:ver.audioName];
        }
    }
}
@end
