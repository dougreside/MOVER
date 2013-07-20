//
//  VersionPopView.m
//  NYPL
//
//  Created by shahnwaz on 10/29/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import "VersionPopView.h"
#import "MainWebControllerViewController.h"
#import "Global.h"
#import "BaseScrollView.h"

@implementation VersionPopView
@synthesize versionArray;
@synthesize mainWebControllerViewController;
@synthesize playTitle;
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return 0;
}
- (BOOL)shouldAutorotate
{
    return NO;
}


-(NSString*)getVersionName:(NSString*)verValue
{
    return verValue;
}

#pragma mark -
#pragma mark UITableView Datasource methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"divider_thin.png"]];
    return [self.versionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    cellIdentifier = [NSString stringWithFormat:@"cell%d%d",indexPath.row,indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel* versionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
        versionLabel.textColor=[UIColor orangeColor];
        versionLabel.tag=indexPath.row+1;
        versionLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:versionLabel];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UILabel* label=(UILabel*)[cell viewWithTag:indexPath.row+1];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.text=[self getVersionName:(NSString*)[self.versionArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view removeFromSuperview];
    int i=currentIndex;
    int j=indexPath.row+1;
    if (i==j)
    {
        UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"NYPL" message:@"Oops we are already on same version." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK ", nil];
        [alertView show];
        return;
    }
    for (; i<j; i++)
    {
        [mainWebControllerViewController.baseScrollView nextView:nil];
    }
    for (; i>j; i--)
    {
        [mainWebControllerViewController.baseScrollView previousView:nil];
    }
}

#pragma mark -
#pragma mark UITableView Delegate methods

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view removeFromSuperview];
}


@end
