//
//  DownloadController.m
//  AR
//
//  Created by Subhash Chand on 3/1/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import "DownloadController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "DownloadData.h"

@implementation DownloadController

@synthesize downloadQueDataList;
@synthesize sender;
@synthesize callBackFuntion;
@synthesize choiceString;
@synthesize controller;

static DownloadController* _sharedDownloadController;

#pragma mark -
#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedDownloadController == nil)
        {
            _sharedDownloadController = [super allocWithZone:zone];			
            return _sharedDownloadController;
        }
    }
    return nil; 
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}



- (void)releaseObject
{
    //do nothing
}


+ (DownloadController*)sharedController
{
	@synchronized(self)
    {
        if (_sharedDownloadController == nil)
        {
           _sharedDownloadController= [[self alloc] init];
        }
    }
    return _sharedDownloadController ;
}


-(void)addLoaderForView
{
	loaderView=[[DownloadingLoaderView alloc]initWithFrame:CGRectMake(0.0, 0.0, controller.frame.size.width, controller.frame.size.height)];
    [loaderView setAlpha:.7];
	[controller addSubview:loaderView];
	[controller bringSubviewToFront:loaderView];
}

-(void)takeItOnFrontOfView
{
   [controller bringSubviewToFront:loaderView];
}

-(void)createDownloadQueForQueData
{
	[self downloadArticalFromServerwithArticleId:nil];
}


-(void)downloadArticalFromServerwithArticleId:(NSString*)articleId
{
    expectedRecivingData = 0.0;
    downloadedData = 0.0;
    NSString *fileContent = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HTML.zip"];
    [self DownloadFilesForArticle:fileContent zipFileName:nil];
}




-(BOOL)stopLoadingFile
{
	if(expectedRecivingData==downloadedData)
	{
		[loaderView removeFromSuperview];
		loaderView=nil;
		if (sender!=nil && callBackFuntion!=nil)
        {
			if ([sender respondsToSelector:callBackFuntion])
            {
            # pragma clang diagnostic ignored "-Warc-performSelector-leaks"
				[sender performSelector:callBackFuntion];
			}
		}
		return TRUE;
	}
	return FALSE;
}


-(void)setExpectedData:(double)expectedData
{
	expectedRecivingData+=expectedData;
}


-(void)appendDataWithDownloadedData:(double)byteData
{
	NSInteger fileIndex;
	fileIndex = currentDownloadIndex + 1;
	if (loaderView==nil)
		return;
	downloadedData+=(double)byteData;
	[loaderView setDisplayMassage:[NSString stringWithFormat:@"%i\%% completed...",(int)(100.0/((double)expectedRecivingData/(double)downloadedData))]];
	[loaderView fillProcessImageForValue:(int)(100.0/((double)expectedRecivingData/(double)downloadedData))];
}

- (BOOL)DownloadFilesForArticle:(NSString*)sourceUrl zipFileName:(NSString *)zipFileName{
    DownloadData* filesdown=[[DownloadData alloc]init];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *appendFiles = [(NSString *)[paths objectAtIndex:0] stringByAppendingPathComponent:zipFileName];
    NSString *documentsDirectory = [(NSString *)appendFiles  stringByAppendingPathComponent:choiceString];
    
    [filesdown setFilePath:[NSString stringWithFormat:@"%@/%@",documentsDirectory,zipFileName]];
    [filesdown setFileDocPath:[NSString stringWithFormat:@"%@/",documentsDirectory]];
    [filesdown startDownload:sourceUrl];
	return TRUE;
}


- (BOOL)doesConnectedToNetworkWithErrorMassage:(NSString*)massage 
{
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	if (!didRetrieveFlags)
		return NO;
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	if(isReachable && !needsConnection) 
	{
		return YES;
	}
	else
	{
		if(massage==nil)
		{
			UIAlertView *baseAlert = [[UIAlertView alloc] 
									  initWithTitle:@"No Network" 
									  message:@"A network connection is required. Please verify your network settings and try again." 
									  delegate:nil cancelButtonTitle:nil 
									  otherButtonTitles:@"OK", nil];	
			[baseAlert show];
		}
		else {
			UIAlertView *baseAlert = [[UIAlertView alloc] 
									  initWithTitle:@"No Network" 
									  message:massage 
									  delegate:nil cancelButtonTitle:nil 
									  otherButtonTitles:@"OK", nil];	
			[baseAlert show];
		}
		
		return NO;
	}
}



@end
