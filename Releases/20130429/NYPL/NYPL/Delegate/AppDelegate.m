//
//  AppDelegate.m
//  NYPL
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PlayViewController.h"
#import "AnnotateViewController.h"
#import "BookmarkViewController.h"
#import "AboutUsViewController.h"
#import "NYPLMenuViewController.h"
#import "MenuObject.h"
#import "ExtraViewController.h"
#import "DatabaseConnection.h"
#import "Global.h"


#import "InitialParser.h"

@implementation AppDelegate
@synthesize nyplMenuViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    currentFontSize = 0;
    // Create DB to cache.
    [[DatabaseConnection sharedConnection] createDatabase:@"NYPL.sqlite"];
     [self initialStuff];
    
    ExtraViewController *extraViewController = [[ExtraViewController alloc] init];
    self.window.rootViewController = extraViewController;
    extraViewController = nil;
    
    [self addTabBar];
   
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Public Method
- (void)addTabBar
{
    nyplMenuViewController = [[NYPLMenuViewController alloc] init];
    [nyplMenuViewController setFrame:CGRectMake(0, 433, 320, 47)];
    
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    MenuObject *rootMenu = [[MenuObject alloc] init];
    [rootMenu setButtonFrame:CGRectZero];
    [rootMenu setViewController:self.viewController];
    [rootMenu setSelectedBtnImage:[UIImage imageNamed:@"btn_play.png"]];
    [rootMenu setNormalBtnImage:[UIImage imageNamed:@"btn_play.png"]];
    
    PlayViewController *playViewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil] ;
    MenuObject *playMenu = [[MenuObject alloc] init];
    [playMenu setButtonFrame:CGRectMake(24, 0, 68, 47)];
    [playMenu setViewController:playViewController];
    [playMenu setSelectedBtnImage:[UIImage imageNamed:@"btn_play.png"]];
    [playMenu setNormalBtnImage:[UIImage imageNamed:@"btn_play.png"]];
    
    
    AnnotateViewController *annotateViewController = [[AnnotateViewController alloc] initWithNibName:@"AnnotateViewController" bundle:nil];
    MenuObject *annotateMenu = [[MenuObject alloc]init];
    [annotateMenu setButtonFrame:CGRectMake(92, 0, 68, 47)];
    [annotateMenu setViewController:annotateViewController];
    [annotateMenu setSelectedBtnImage:[UIImage imageNamed:@"btn_annotate.png"]];
    [annotateMenu setNormalBtnImage:[UIImage imageNamed:@"btn_annotate.png"]];
    
    
    BookmarkViewController *bookmarkViewController = [[BookmarkViewController alloc] initWithNibName:@"BookmarkViewController" bundle:nil];
    MenuObject *bookmarkMenu = [[MenuObject alloc]init];
    [bookmarkMenu setButtonFrame:CGRectMake(160, 0, 68, 47)];
    [bookmarkMenu setViewController:bookmarkViewController];
    [bookmarkMenu setSelectedBtnImage:[UIImage imageNamed:@"btn_bookmarks.png"]];
    [bookmarkMenu setNormalBtnImage:[UIImage imageNamed:@"btn_bookmarks.png"]];
    
    
    AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    MenuObject *aboutUsMenu = [[MenuObject alloc]init];
    [aboutUsMenu setButtonFrame:CGRectMake(228, 0, 68, 47)];
    [aboutUsMenu setViewController:aboutUsViewController];
    [aboutUsMenu setSelectedBtnImage:[UIImage imageNamed:@"btn_about.png"]];
    [aboutUsMenu setNormalBtnImage:[UIImage imageNamed:@"btn_about.png"]];
    
    [nyplMenuViewController addViewControllers:[NSArray arrayWithObjects: rootMenu, playMenu, annotateMenu, bookmarkMenu, aboutUsMenu,nil]];
}

#pragma mark - Private methods
- (void)initialStuff {
    InitialParser *parser = [[InitialParser alloc]init];
    [parser parsePlayInfo];
    [parser parseVersionXMLFile];
}
@end