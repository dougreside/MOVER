//
//  AnnotateViewController.h
//  NYPL
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotateViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITextField* noteSearchBar;
    IBOutlet UILabel* infoLabel;
    IBOutlet UILabel* titleLabel;
}
@property(nonatomic,retain) IBOutlet UITableView* noteTableView;
@property(nonatomic,retain)  NSMutableArray* filteredListContent;
@property(nonatomic,retain)  NSArray* dataArray;
@property (nonatomic,retain) NSMutableDictionary *sections;
-(IBAction)Back_Clicked:(id)sender;
-(void)setDataForPlay;
-(void)checkStatusOfInfoLabel;
-(void)getDataForAnnotateTable;

@end
