//
//  Version.h
//  NYPL
//
//  Created by shahnwaz on 10/30/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//
//  Edited --@prakash

#import <Foundation/Foundation.h>

@interface Version : NSObject
@property (nonatomic, assign) NSInteger playId;
@property (nonatomic, assign) NSInteger versionId;
@property (nonatomic, retain) NSString *versionName;
@property (nonatomic, retain) NSString *htmlFileName;
@property (nonatomic, retain) NSString *audioName;
@property (nonatomic, assign) NSInteger bookmark;
@property (nonatomic, retain) NSString *notes;
@end
