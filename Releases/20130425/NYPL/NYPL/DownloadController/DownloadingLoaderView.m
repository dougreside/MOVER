//
//  DownloadingLoaderView.m
//  AR
//
//  Created by Subhash Chand on 3/1/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import "DownloadingLoaderView.h"
#import "Global.h"
#define PROCESS_BAR_WIDTH 290.0
#define PROCESS_BAR_HEIGHT 20.0


@implementation DownloadingLoaderView


- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
    {
		self.backgroundColor = [UIColor blackColor];
		self.alpha=0.60;
		downloadlbl=[[UILabel alloc]initWithFrame:CGRectMake(0.0, (self.frame.size.height-70)/2+75, self.frame.size.width, 30)];
		downloadlbl.backgroundColor=[UIColor clearColor];
		[downloadlbl setTextColor:[UIColor whiteColor]];
		[downloadlbl setTextAlignment:NSTextAlignmentCenter];
		 downloadlbl.font=[UIFont boldSystemFontOfSize:15];
		downloadlbl.text=@"Initializing App data...";
		[self addSubview:downloadlbl];
		
		
		downloadArticle=[[UILabel alloc]initWithFrame:CGRectMake(0.0, (self.frame.size.height-70)/2+45, self.frame.size.width, 30)];
		downloadArticle.backgroundColor=[UIColor clearColor];
		[downloadArticle setTextColor:[UIColor whiteColor]];
		[downloadArticle setTextAlignment:NSTextAlignmentCenter];
		downloadArticle.font=[UIFont boldSystemFontOfSize:20];
		[self addSubview:downloadArticle];
		
		indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.frame.size.width-40)/2-18,(self.frame.size.height-90)/2+20,70,70)];
		indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[self addSubview:indicatorView];
		[indicatorView startAnimating];
        
        
        // Initialization code
		processBgImage=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-PROCESS_BAR_WIDTH)/2,  (self.frame.size.height-70)/2+120, PROCESS_BAR_WIDTH, PROCESS_BAR_HEIGHT)];
		[processBgImage setImage:[UIImage imageNamed:@"Process_bar.png"]];
		[self addSubview:processBgImage];
		processBgImage.hidden=YES;
		processFillImage=[[UIImageView alloc]initWithFrame:CGRectMake(5,  5, PROCESS_BAR_WIDTH-10, PROCESS_BAR_HEIGHT-10)];
		[processFillImage setImage:[UIImage imageNamed:@"Process-bar-loader.png"]];        
        downloadlbl.frame=CGRectMake(downloadlbl.frame.origin.x, downloadlbl.frame.origin.y-10, downloadlbl.frame.size.width, downloadlbl.frame.size.height);
    }
    return self;
}


-(void)setDownloadedArticle:(NSString*)massageString 
{
	[downloadArticle setText:massageString];
}

-(void)setDisplayMassage:(NSString*)massageString
{
	[downloadlbl setText:massageString];
}

-(void)fillProcessImageForValue:(NSInteger)value
{
	if(processBgImage.hidden==YES)
		processBgImage.hidden=NO;
	if(value>0)
		[processBgImage addSubview:processFillImage];
	processFillImage.frame=CGRectMake(0.0, 0.0, value*(PROCESS_BAR_WIDTH/100), PROCESS_BAR_HEIGHT);
}





@end
