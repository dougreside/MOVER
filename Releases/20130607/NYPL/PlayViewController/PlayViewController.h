//
//  PlayViewController.h
//  NYPL
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewController : UIViewController
<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel* infoLabel;
    IBOutlet UITextField* playSearchBar;
    IBOutlet UILabel* titleLabel;
}

@property (nonatomic,retain) NSMutableArray* filteredListContent;
@property (nonatomic,retain) NSArray* dataArray;
@property (nonatomic,retain) NSMutableDictionary *sections;
@property (nonatomic,retain) NSString* searchText;
@property (nonatomic,retain) IBOutlet UITableView* playTableView;

-(IBAction)Back_Clicked:(id)sender;
-(void)setDataForPlay;
-(void)onClcikHeaderButton:(id)sender;
@end
