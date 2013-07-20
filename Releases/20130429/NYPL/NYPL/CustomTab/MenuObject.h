//
//  MenuObject.h
//  MuslimCare
//
//  Created by kiwitech on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface MenuObject : NSObject
{
    id  viewController;
	NSString *menuButtonTitle;
	UIImage *normalBtnImage;
	UIImage *selectedBtnImage;
	CGRect buttonFrame;
}
@property (nonatomic, assign) CGRect buttonFrame;
@property (nonatomic, retain)  id viewController;
@property (nonatomic, retain) NSString *menuButtonTitle;
@property (nonatomic, retain) UIImage *normalBtnImage;
@property (nonatomic, retain) UIImage *selectedBtnImage;
@end
