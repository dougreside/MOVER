//
//  Favorite.m
//  NYPL
//
//  Created by shahnwaz on 10/25/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//
//  Edited --@prakash

#import "Play.h"

@implementation Play
@synthesize isFav;
@synthesize playId;

@synthesize playTitle;
@synthesize imageURL;

@synthesize authorName;
@synthesize captionName;

@synthesize authorInfo;

- (void)dealloc {
    self.playTitle = nil;
    self.authorName = nil;
    self.captionName = nil;
    self.imageURL = nil;
    self.authorInfo  = nil;
}
@end
