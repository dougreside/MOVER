//
//  Favorite.h
//  NYPL
//
//  Created by shahnwaz on 10/25/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//
//  Edited --@prakash

#import <Foundation/Foundation.h>

@interface Play : NSObject
@property (nonatomic, assign) int playId;
@property (nonatomic, assign) int isFav;

@property (nonatomic, retain) NSString *playTitle;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *authorName;
@property (nonatomic, retain) NSString *captionName;
@property (nonatomic, retain) NSString *authorInfo;
@end
