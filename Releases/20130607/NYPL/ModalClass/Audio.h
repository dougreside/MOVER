//
//  Audio.h
//  NYPL
//
//  Created by shahnwaz on 1/3/13.
//  Copyright (c) 2013 shahnwaz. All rights reserved.
//
//  Edited --@prakash

#import <Foundation/Foundation.h>

@interface Audio : NSObject
@property (nonatomic, assign) NSInteger playId;
@property (nonatomic, assign) NSInteger versionId;
@property (nonatomic, assign) NSInteger clipId;
@property (nonatomic, assign) NSInteger fromTime;
@property (nonatomic, assign) NSInteger toTime;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, retain) NSString *audioFileName;

@end
