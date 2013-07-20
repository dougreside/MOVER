//
//  RBOMenuViewController.h
//  MuslimCare
//
//  Created by kiwitech on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Global.h"


@interface NYPLMenuViewController : UIView 
{
	float totalBtnsWidth;
	int   totalMenuBtn;
	UIButton *previousSelectedBtn;
	UIButton *tempBtn;
	UINavigationController *previousNavigationView;
    UIImageView *backgroundImageView;
    NSMutableArray *navigationMenuObjects;
}

@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, assign) BOOL backFlag;

-(void)addViewControllers:(NSArray *)menuArray;
-(IBAction)menuBtnClicked:(id)sender;
-(void)addjustMenuBtn;
-(void)showRequiredController:(HighlightedTab)requiredTab;
@end
