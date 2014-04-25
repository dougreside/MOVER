//
//  CustomView.h
//  SlideShowTest
//
//  Created by kiwitech on 09/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CustomView : UIView <UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic,assign) BOOL isPdfForDisplay;
@property (nonatomic,assign) BOOL wantsToMovePDf;
@property (nonatomic,retain) UIWebView *currentWebView;

- (id)initWithFrame:(CGRect)frame forViews:(NSArray *)viewsArray
         forIndexes:(NSArray *)tagsArray forDelegate:(id)del;
- (NSString *)getFilePathNameForArticleId:(NSString *)folderName
                            andFileName:(NSString*)fileName;
@end
