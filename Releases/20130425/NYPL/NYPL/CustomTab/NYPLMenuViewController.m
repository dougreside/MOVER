//
//  RBOMenuViewController.m
//  MuslimCare
//
//  Created by kiwitech on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "NYPLMenuViewController.h"
#import "AppDelegate.h"
#import "MenuObject.h"
#import "Global.h"
#import "PlayViewController.h"
#import "AnnotateViewController.h"
#import "BookmarkViewController.h"

@implementation NYPLMenuViewController

@synthesize backgroundImageView;
@synthesize backFlag;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        navigationMenuObjects=[[NSMutableArray alloc]init];
    }
    return self;
}


#pragma mark addViewControllers

- (void)addViewControllers:(NSArray*)menuArray
{
	id appDelegate = [[UIApplication sharedApplication]delegate];
	totalBtnsWidth = 0.0;
	totalMenuBtn = 1;
	BOOL isScalingNotRequired = FALSE;
	
	for (int menuIndex = 0; menuIndex < [menuArray count]; menuIndex++) {
        
		MenuObject *menuObject = (MenuObject*)[menuArray objectAtIndex:menuIndex];
		UINavigationController *viewNavigationController = [[UINavigationController alloc]initWithRootViewController:menuObject.viewController];
		[navigationMenuObjects addObject:viewNavigationController];
        viewNavigationController.navigationBar.hidden = YES;
		UIButton *menuBtn = nil;
        
		if(menuObject.normalBtnImage) {
			if(menuObject.buttonFrame.size.width > 0) {
				menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(menuObject.buttonFrame.origin.x, menuObject.buttonFrame.origin.y, menuObject.buttonFrame.size.width, menuObject.buttonFrame.size.height)] ;
				isScalingNotRequired = TRUE;
                
			} else {
				if(isScalingNotRequired) {
					UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"CustomTabBar" message:[NSString stringWithFormat:@"You must have to provide frame of tab %i.",menuIndex] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alertView show];
                    alertView = nil;
				}
                
				menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, menuObject.normalBtnImage.size.width, menuObject.normalBtnImage.size.height)];
			}
            
			[menuBtn setImage:menuObject.normalBtnImage forState:UIControlStateNormal];
			[menuBtn setImage:menuObject.selectedBtnImage forState:UIControlStateSelected];
			[menuBtn setTag:menuIndex];
			[menuBtn addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:menuBtn];
			
			if(menuIndex < 1) {
				[menuBtn setHidden:YES];
            }
			totalBtnsWidth += menuBtn.frame.size.width;
			totalMenuBtn++;
		}
		
		if(menuIndex == 0) {
			[viewNavigationController.view addSubview:self];
            [[appDelegate window] setRootViewController:viewNavigationController];
			previousNavigationView = viewNavigationController;
			[[appDelegate window] bringSubviewToFront:self];
			previousSelectedBtn = menuBtn;
			[menuBtn setSelected:TRUE];
		}
	}
	
	if(!isScalingNotRequired)
		[self addjustMenuBtn];
}	

- (void)addjustMenuBtn
{
	float viewHorizontalSpacing = (self.frame.size.width-totalBtnsWidth)/totalMenuBtn;
	float xOffset = 0.0;
    
	for (UIView *view in self.subviews) {
		if([view isKindOfClass:[UIButton class]]) {
			xOffset += viewHorizontalSpacing;			
			view.frame=CGRectMake(xOffset, (self.frame.size.height-view.frame.size.height)/2, view.frame.size.width, view.frame.size.height);
			xOffset += view.frame.size.width;
		}
	}
}


#pragma mark menuBtnClickedAction

- (IBAction)menuBtnClicked:(id)sender
{
	tempBtn = (UIButton *)sender;
    
    if(tempBtn.tag < [navigationMenuObjects count]) {
        
        [previousSelectedBtn setSelected:FALSE];
        [tempBtn setSelected:TRUE];
        previousSelectedBtn = tempBtn;
        id appDelegate = [[UIApplication sharedApplication]delegate];
        UINavigationController *currentNavigationController = [navigationMenuObjects objectAtIndex:tempBtn.tag];
        id obj = [currentNavigationController.viewControllers objectAtIndex:0];
        
        if([obj isKindOfClass:[PlayViewController class]]) {
            PlayViewController* objPlay = (PlayViewController*)obj;
            [objPlay.playTableView reloadData];
        }
        
        if([obj isKindOfClass:[AnnotateViewController class]]) {
            AnnotateViewController* objAno = (AnnotateViewController*)obj;
            [objAno.noteTableView reloadData];
        }
        
        if([obj isKindOfClass:[BookmarkViewController class]]) {
            BookmarkViewController* objBok = (BookmarkViewController*)obj;
            [objBok.bookmarkTableView reloadData];
        }
        [previousNavigationView.view removeFromSuperview];
        [currentNavigationController.view addSubview:self];
        [[appDelegate window] setRootViewController:currentNavigationController];
        previousNavigationView = currentNavigationController;
        [[appDelegate window] bringSubviewToFront:self];
    }
}


#pragma mark -
#pragma mark showRequiredController
- (void)showRequiredController:(HighlightedTab)requiredTab
{
	for (UIView *view in self.subviews) {
		if([view isKindOfClass:[UIButton class]]) {
			if(view.tag == requiredTab) {
                [self menuBtnClicked:view];
                break;
            }
		}
	}
}
@end