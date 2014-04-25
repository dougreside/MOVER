//
//  ViewController.h
//  NYPL
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ViewController : UIViewController
<iCarouselDataSource, iCarouselDelegate, UITextFieldDelegate>
{
    IBOutlet iCarousel *icarousel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *authorLabel;
    IBOutlet UILabel *contentLabel;
    IBOutlet UITextField *allPlaySearchBar;
    NSInteger currnetPlayID;
    NSArray *_dataArray;
}
@property(nonatomic, retain)  NSString *currentPlayAuthor, *playTitle;
@property(nonatomic, assign)   NSInteger currnetPlayID;

- (IBAction)FullText_Clicked:(id)sender;
- (void)unzippingHTMLFile;
- (void)setFontSetting;
@end
