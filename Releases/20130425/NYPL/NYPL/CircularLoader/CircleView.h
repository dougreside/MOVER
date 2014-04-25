//
//  CircleView.h
//  CircleView
//
//  Created by RAVI DAS on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoundLoader;
@interface CircleView : UIView

@property (nonatomic,assign) IBOutlet CGFloat radius;
@property (nonatomic, strong) IBOutlet RoundLoader* loader;
@property (nonatomic, strong) IBOutlet UILabel* percentageLbl;
- (void)addLoaderView:(int)percentComplete;
+ (CircleView *)sharedView;
@end
