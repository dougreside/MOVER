//
//  Audio.m
//  NYPL
//
//  Created by shahnwaz on 1/3/13.
//  Copyright (c) 2013 shahnwaz. All rights reserved.
//
//  Edited --@prakash

#import "Audio.h"

@implementation Audio

@synthesize playId;
@synthesize versionId;
@synthesize clipId;
@synthesize fromTime;
@synthesize toTime;
@synthesize selected;
@synthesize audioFileName;

- (void)dealloc {
    self.audioFileName = nil;
}
@end
