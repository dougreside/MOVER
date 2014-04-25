//
//  DownloadData.m
//  DownloadArticle
//
//  Created by Kiwitech Noida on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadData.h"
#import "ZipArchive.h"
#import "DownloadController.h"


@implementation DownloadData
@synthesize filePath;
@synthesize fileDocPath;
@synthesize serverUrl;

- (void)startDownload:(NSString *)fileURL
{
	serverUrl = fileURL;
	
	NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"HTML.zip" withExtension:nil];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:pdfURL];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) 
    {
		[connection start];
	} else 
    {
		// Handle error
		DownloadController *downloadController=[DownloadController sharedController];
		[downloadController stopLoadingFile];
	}
    //[connection release];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
	NSFileManager *filemanager=[NSFileManager defaultManager];
	if(![filemanager fileExistsAtPath:filePath])
		[[NSFileManager defaultManager] createFileAtPath:filePath	contents: nil attributes: nil];
    
	NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
	[handle seekToEndOfFile];
	[handle writeData:data];
    
	DownloadController *downloadController=[DownloadController sharedController];
	[downloadController appendDataWithDownloadedData:[data length]];
	
	[handle closeFile];
}

- (void)connection:(NSURLConnection *)connection  didFailWithError:(NSError *)error
{
    
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Download" message:[NSString stringWithFormat:@"Connection failed! Error - %@ ", [error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show]; alertView = nil;
	
	DownloadController *downloadController=[DownloadController sharedController];
	[downloadController stopLoadingFile];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	DownloadController *downloadController=[DownloadController sharedController];
	totalexpectedData=(double)[response expectedContentLength];
	[downloadController setExpectedData:totalexpectedData];
	NSFileManager *filemanager=[NSFileManager defaultManager];
    
	if(![filemanager contentsOfDirectoryAtPath:fileDocPath error:nil])
		[filemanager createDirectoryAtPath:fileDocPath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    NSLog(@"Succeeded! Received bytes of data");
	
	ZipArchive *za = [[ZipArchive alloc] init];
	if ([za UnzipOpenFile: filePath]) {
		BOOL ret = [za UnzipFileTo:fileDocPath overWrite: YES];
		if (NO == ret){} [za UnzipCloseFile];
	}
	//[za release];
    
	NSFileManager *filemanager=[NSFileManager defaultManager];
	NSError *error;
	if([filemanager fileExistsAtPath:filePath])
		[filemanager removeItemAtPath:filePath error:&error];
	
	DownloadController *downloadController=[DownloadController sharedController];
	[downloadController stopLoadingFile];
	
}

- (void)didReceiveMemoryWarning {
}
@end
