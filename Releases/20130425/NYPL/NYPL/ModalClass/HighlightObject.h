//
//  HighlightObject.h
//  NYPL
//
//  Created by shahnwaz on 11/1/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighlightObject : NSObject
@property (nonatomic,assign) int _id, playId,versionNo;
@property (nonatomic,retain) NSString* highlightId,*note,*selectedText,*playAuthorName,*playTitle;
@end
