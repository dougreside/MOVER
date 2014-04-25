//
//  BookmarkViewController.h
//  NYPL
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarkViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITextField* bookmarkSearchBar;
    IBOutlet UILabel* infoLabel;
    IBOutlet UIButton* doneBtn;
    IBOutlet UILabel* titleLabel;
}
@property(nonatomic,retain) IBOutlet UITableView* bookmarkTableView;
@property(nonatomic,retain)  NSMutableArray* filteredListContent;
@property(nonatomic,retain)  NSArray* dataArray;
@property (nonatomic,retain) NSMutableDictionary *sections;
-(IBAction)Back_Clicked:(id)sender;
-(void)setDataForPlay;
-(void)checkStatusOfInfoLabel;
-(void)getDataForBookmarkTable;
-(void)checkPropertyOfDoneButton;
@end
