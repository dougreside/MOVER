//
//  AnnotateViewController.m
//  NYPL
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import "AnnotateViewController.h"
#import "AppDelegate.h"
#import "NYPLMenuViewController.h"
#import "Global.h"
#import "PlayCustomCell.h"
#import "HighlightObject.h"
#import "DatabaseConnection.h"
#import "MainWebControllerViewController.h"
#import "BaseScrollView.h"

@implementation AnnotateViewController
@synthesize filteredListContent;
@synthesize sections;
@synthesize dataArray=_dataArray;
@synthesize noteTableView;

#pragma mark -
#pragma mark User Loading  methods

-(void)viewDidAppear:(BOOL)animated
{
    noteSearchBar.text = @"";

    [self getDataForAnnotateTable];
}

- (void)viewDidLoad
{
    self.filteredListContent = [[NSMutableArray alloc] init];
    self.sections = [[NSMutableDictionary alloc] init];
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterContentforText) name:UITextFieldTextDidChangeNotification object:nil];
    // text Font/Color Setting
    UIFont* myFont = FONT_TAHOMA_REGULAR(13);
    [titleLabel setFont:myFont];
    titleLabel.textColor = kColor(255, 154, 4, 1);
    noteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return 0;
}
- (BOOL)shouldAutorotate
{
     [self getDataForAnnotateTable];
    return NO;
}


#pragma mark -
#pragma mark User Define  methods

- (void)getDataForAnnotateTable
{
    [self.filteredListContent removeAllObjects];
    DatabaseConnection* dbCon = [DatabaseConnection sharedConnection];
    _dataArray=[dbCon SelectHighlightObjectDetail:[NSString stringWithFormat:@"Select * from HIGHLIGHTOBJECT"]];
    self.filteredListContent = [[dbCon SelectHighlightObjectDetail:[NSString stringWithFormat:@"Select * from HIGHLIGHTOBJECT"]] mutableCopy];
    [self setDataForPlay];
    [self checkStatusOfInfoLabel];
    [noteTableView reloadData];
}

- (void)checkStatusOfInfoLabel
{
    if ([self.filteredListContent count]==0)
        infoLabel.hidden=FALSE;
    else
        infoLabel.hidden=TRUE;
}

- (void)setDataForPlay
{
    self.sections = [[NSMutableDictionary alloc] init];
    BOOL found;
    // Loop through the Play and create our keys
    for (HighlightObject *hghObj in self.filteredListContent)
    {
        NSString *c = [hghObj.playTitle substringToIndex:1];
        found = NO;
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
                found = YES;
        }
        if (!found)
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
    }
    // Loop again and sort the Play into their respective keys
    for (HighlightObject *hghObj in self.filteredListContent)
        [[self.sections objectForKey:[hghObj.playTitle substringToIndex:1]] addObject:hghObj];
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"playTitle" ascending:YES]]];    
}

- (void)filterContentforText
{
    NSString* string = noteSearchBar.text;
    [self.filteredListContent removeAllObjects]; // First clear the filtered array.
    for (HighlightObject *product in _dataArray)
    {
        NSComparisonResult result = [product.playTitle compare:string options:(NSCaseInsensitiveSearch) range:NSMakeRange(0, string.length)];
        if (result == NSOrderedSame)
            [self.filteredListContent addObject:product];
    }
    [self setDataForPlay];
    [noteTableView reloadData];
    [self checkStatusOfInfoLabel];
}

#pragma mark -
#pragma mark UIButton Event methods


- (IBAction)Back_Clicked:(id)sender
{
    AppDelegate* delegate=[UIApplication sharedApplication].delegate;
    [delegate.nyplMenuViewController showRequiredController:RootTabSelected];
    delegate.nyplMenuViewController.hidden=NO;
    noteSearchBar.text=@"";
}

#pragma mark -
#pragma mark UITableView Datasource methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    cellIdentifier = [NSString stringWithFormat:@"cell%d%d",indexPath.row,indexPath.section];
    PlayCustomCell *cell = (PlayCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        UIViewController* viewController = [[UIViewController alloc] initWithNibName:@"PlayCustomCell" bundle:nil];
        cell = (PlayCustomCell*)viewController.view;
        viewController = nil;
    }
    HighlightObject *hghObj = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]
                                                           objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    UIFont* myFont=FONT_TAHOMA_BOLD(15);
    [cell.titleLable setFont:myFont];
    cell.titleLable.textColor = kColor(154, 4, 4, 1);
    
    myFont=FONT_TAHOMA_REGULAR(13);
    [cell.authorLabel setFont:myFont];
    cell.authorLabel.textColor = kColor(41, 42, 42, 1);
    
    cell.titleLable.text = hghObj.playTitle;
    cell.authorLabel.text = hghObj.playAuthorName;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero] ;
    cell.selectedBackgroundView.backgroundColor = kColor(106, 5, 5, 1);
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *image = [UIImage imageNamed:@"bar_red.png"];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageview.image = image;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width-20, image.size.height/2-11, 20, 20)];
    labelTitle.text = [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    UIFont* myfont=FONT_TAHOMA_BOLD(13);
    [labelTitle setFont:myfont];
    [imageview addSubview:labelTitle];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = kColor(255, 154, 4, 1);
    return imageview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.sections allKeys] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [noteSearchBar resignFirstResponder];
    MainWebControllerViewController* mainWebControllerViewController=[[MainWebControllerViewController alloc] initWithNibName:@"MainWebControllerViewController" bundle:nil];
    HighlightObject *hghObj = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]
                                                           objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    currentIndex=hghObj.versionNo;
    mainWebControllerViewController.playID=hghObj.playId;
    [mainWebControllerViewController.baseScrollView manageViewOnMove:((HighlightObject*)[self.filteredListContent objectAtIndex:indexPath.section]).versionNo];
    [self.navigationController pushViewController:mainWebControllerViewController animated:YES];
    noteSearchBar.text=@"";
}

#pragma mark -
#pragma mark UITextfield Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self checkStatusOfInfoLabel];
}

@end
