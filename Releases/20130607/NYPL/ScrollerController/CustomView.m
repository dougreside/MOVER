 //
//  CustomView.m
//  SlideShowTest
//
//  Created by kiwitech on 09/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomView.h"
#import "BaseScrollView.h"


@implementation CustomView
@synthesize isPdfForDisplay;
@synthesize wantsToMovePDf;
@synthesize currentWebView;
BOOL wantsGesture;


- (id)initWithFrame:(CGRect)frame forViews:(NSArray *)viewsArray
         forIndexes:(NSArray *)tagsArray forDelegate:(id)del {
    
    self = [super initWithFrame:frame];
    if (self) {
        wantsToMovePDf=YES;
        for(int i=1; i<=[viewsArray count]; i++) {
            UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake((i*(frame.size.width/numberOfViewsOnScreen)) -(frame.size.width/numberOfViewsOnScreen)+10, 10, 280, 360)];
            //NSLog(@"FileName=%@",[viewsArray objectAtIndex:i-1]);
//            NSLog(@"Count=%i",[viewsArray count]);
            NSString* url = [self getFilePathNameForArticleId:@"HTML" andFileName:[viewsArray objectAtIndex:i-1]];
            NSURL *URL = [NSURL fileURLWithPath:url];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL];
            [web  loadRequest:urlRequest];
            [self addSubview:web];
            [web setDelegate:del];
            self.isPdfForDisplay = NO;
            self.currentWebView = web;
            web.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

- (NSString *)getFilePathNameForArticleId:(NSString *)folderName
                              andFileName:(NSString*)fileName {
    
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSMutableString *documentsDirectory = [[NSMutableString alloc]initWithString:[paths objectAtIndex:0]];
	documentsDirectory = (NSMutableString*)[documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",folderName,fileName]];
	if(![fileManager fileExistsAtPath:documentsDirectory])
		return nil;
	return documentsDirectory;
}
@end