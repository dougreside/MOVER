//
//  Bookmark.h
//  NYPL
//
//  Created by shahnwaz on 11/2/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bookmark : NSObject
@property (nonatomic,assign) int _id, playId,versionNo;
@property (nonatomic,retain) NSString* playAuthorName,*playTitle,*imageName;
@end
