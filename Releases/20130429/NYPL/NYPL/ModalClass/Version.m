//
//  Version.m
//  NYPL
//
//  Created by shahnwaz on 10/30/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//
//  Edited --@prakash

#import "Version.h"

@implementation Version
@synthesize versionId;
@synthesize playId;
@synthesize htmlFileName;
@synthesize versionName;
@synthesize audioName;

@synthesize bookmark;
@synthesize notes;

- (void)dealloc {
    self.htmlFileName = nil;
    self.versionName = nil;
    self.audioName = nil;
    self.notes = nil;
}
@end
