//
//  DownloadData.h
//  DownloadArticle
//
//  Created by Kiwitech Noida on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadData : NSObject {
    
	NSString *filePath;
	NSString *fileDocPath;
	NSString *serverUrl;
	double totalexpectedData;
}
@property (nonatomic, retain) NSString *serverUrl;

@property(nonatomic,retain)NSString *fileDocPath;
@property(nonatomic,retain)NSString *filePath;

//- (void)startDownload:(NSString *)fileURL withOffset:(int)offset;
- (void)startDownload:(NSString *)fileURL; 

@end
