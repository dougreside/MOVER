//
//  VersionPopView.h
//  NYPL
//
//  Created by shahnwaz on 10/29/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainWebControllerViewController;
@interface VersionPopView : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) NSArray* versionArray;
@property (nonatomic,retain) MainWebControllerViewController* mainWebControllerViewController;
@property (nonatomic,retain) NSString* playTitle;
-(NSString*)getVersionName:(NSString*)verValue;
@end
