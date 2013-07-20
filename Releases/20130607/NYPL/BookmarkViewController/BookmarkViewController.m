//
//  BookmarkViewController.m
//  NYPL
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import "BookmarkViewController.h"
#import "AppDelegate.h"
#import "NYPLMenuViewController.h"
#import "Global.h"
#import "Bookmark.h"
#import "DatabaseConnection.h"
#import "PlayCustomCell.h"
#import "MainWebControllerViewController.h"
#import "BaseScrollView.h"


@implementation BookmarkViewController
@synthesize filteredListContent;
@synthesize sections;
@synthesize dataArray = _dataArray;
@synthesize bookmarkTableView;

#pragma mark -
#pragma mark User Loading  methods

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    bookmarkSearchBar.text = @"";
    [self getDataForBookmarkTable];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filteredListContent = [[NSMutableArray alloc] init];
    self.sections = [[NSMutableDictionary alloc] init];
    [self getDataForBookmarkTable];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterContentforText) name:UITextFieldTextDidChangeNotification object:nil];
    
    //Font Setting
    UIFont* myFont = FONT_TAHOMA_REGULAR(17);
    [titleLabel setFont:myFont];
    titleLabel.textColor = kColor(255, 154, 4, 1);
    bookmarkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [super viewDidUnload];
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return 0;
}
- (BOOL)shouldAutorotate
{
    [bookmarkTableView setEditing:NO animated:NO];
    [self getDataForBookmarkTable];
    return NO;
}

#pragma mark -
#pragma mark User Define  methods

- (void)getDataForBookmarkTable
{
    DatabaseConnection*dbCon = [DatabaseConnection sharedConnection];
    _dataArray = [dbCon SelectBookmarkDetail:[NSString stringWithFormat:@"Select * from BOOKMARK"]];
    self.filteredListContent = [_dataArray mutableCopy];
    [self setDataForPlay];
    [self checkStatusOfInfoLabel];
    [self checkPropertyOfDoneButton];
    [bookmarkTableView reloadData];
}

- (void)checkStatusOfInfoLabel
{
    infoLabel.hidden = ([self.filteredListContent count] > 0);
}


- (void)checkPropertyOfDoneButton
{
    if ([filteredListContent count]==0) {
        [doneBtn setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
        [doneBtn setEnabled:FALSE];
        
    } else {
        if (bookmarkTableView.editing)
            [doneBtn setImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
        else
            [doneBtn setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
        [doneBtn setEnabled:TRUE];
    }
}


- (void)setDataForPlay
{
    self.sections = [[NSMutableDictionary alloc] init];
    BOOL found;
    // Loop through the Play and create our keys
    for (Bookmark *bookmark in self.filteredListContent)
    {
        NSString *c = [bookmark.playTitle substringToIndex:1];
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
    for (Bookmark *bookmark in self.filteredListContent)
        [[self.sections objectForKey:[bookmark.playTitle substringToIndex:1]] addObject:bookmark];
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"playTitle" ascending:YES]]];
}

- (void)filterContentforText
{
    NSString* string = bookmarkSearchBar.text;
    [self.filteredListContent removeAllObjects]; // First clear the filtered array.
    for (Bookmark *product in _dataArray)
    {
        NSComparisonResult result = [product.playTitle compare:string options:(NSCaseInsensitiveSearch) range:NSMakeRange(0, string.length)];
        if (result == NSOrderedSame)
            [self.filteredListContent addObject:product];
    }
    [self setDataForPlay];
    [bookmarkTableView reloadData];
    [self checkStatusOfInfoLabel];
}


#pragma mark -
#pragma mark UIButton Event methods

- (IBAction)Back_Clicked:(id)sender
{
    AppDelegate* delegate=[UIApplication sharedApplication].delegate;
    [delegate.nyplMenuViewController showRequiredController:RootTabSelected];
    delegate.nyplMenuViewController.hidden=NO;
    bookmarkSearchBar.text=@"";
}

- (IBAction)Edit_Clicked:(id)sender
{
    if(bookmarkTableView.editing && [self.filteredListContent count] > 0) {
        [super setEditing:NO animated:NO];
        [bookmarkTableView setEditing:NO animated:NO];
        [bookmarkTableView reloadData];
        [doneBtn setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
        
    } else if ([self.filteredListContent count] > 0) {
        [super setEditing:YES animated:YES];
        [bookmarkTableView setEditing:YES animated:YES];
        [bookmarkTableView reloadData];
        [doneBtn setImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    }
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
    Bookmark *bookmark = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.titleLable.text = bookmark.playTitle;
    cell.authorLabel.text = bookmark.playAuthorName;
    UIFont* myFont=FONT_TAHOMA_BOLD(15);
    [cell.titleLable setFont:myFont];
    cell.titleLable.textColor = kColor(154, 4, 4, 1);
    
    myFont=FONT_TAHOMA_REGULAR(13);
    [cell.authorLabel setFont:myFont];
    cell.authorLabel.textColor = kColor(42, 42, 42, 1);
    
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
    
    [bookmarkSearchBar resignFirstResponder];
    MainWebControllerViewController* mainWebControllerViewController=[[MainWebControllerViewController alloc] initWithNibName:@"MainWebControllerViewController" bundle:nil];
   
    Bookmark *bookmark = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    mainWebControllerViewController.playID=bookmark.playId;
    currentIndex=bookmark.versionNo;
    [self.navigationController pushViewController:mainWebControllerViewController animated:YES];
    bookmarkSearchBar.text=@"";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing == NO || !indexPath)
        return UITableViewCellEditingStyleNone;
    else if (self.editing && indexPath.row == ([self.filteredListContent count]))
		return UITableViewCellEditingStyleInsert;
    else
		return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DatabaseConnection *dcon = [DatabaseConnection sharedConnection];
        Bookmark *bookmarkObject =(Bookmark*) [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        NSString* query = [NSString stringWithFormat:@"delete from BOOKMARK where PLAY_ID = \"%d\" and VERSION_NO=%d",bookmarkObject.playId,bookmarkObject.versionNo];
        [dcon deleteRowOfBookMarkTable:query];
        [self getDataForBookmarkTable];
        [aTableView reloadData];
        [self checkPropertyOfDoneButton];
        [self checkStatusOfInfoLabel];
    }
}


#pragma mark -
#pragma mark UITextfield Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
