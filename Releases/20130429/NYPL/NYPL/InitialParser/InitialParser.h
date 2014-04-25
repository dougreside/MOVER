//
//  InitialParser.h
//  NYPL
//
//  Created by Prakash Raj on 20/03/13.
//  Copyright (c) 2013 kiwitech. All rights reserved.
//

/*
 * A model class is written to gather parse the initially provided XML information like aboutus, constant_metadata, keywords. The class is also responsible to cache thease value for future use in application.
 */

#import <Foundation/Foundation.h>

typedef enum ParsingType {
    kParsingNone = 0,
    kParsingVersion,
    kParsingAudio,
} kParsingType;

@class Audio;
@interface InitialParser : NSObject <NSXMLParserDelegate> {
    NSMutableString  *_currentElementValue;
    NSXMLParser      *_parser;
    kParsingType     _parsingType;
    
    NSMutableArray *_versions;
    Audio *_audio;
}

- (void)parseVersionXMLFile;
- (void)parsePlayInfo;
- (void)parseAudioFile:(NSString *)audiofile;
@end