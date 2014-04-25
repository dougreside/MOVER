//
//  RoundLoader.h
//  XMLParser
//
//  Created by Samar Gupta on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundLoader : UIView
@property(nonatomic)float radius;
@property(nonatomic)float widthOfRadius;
- (void)startAnimation:(float)startAngle endAngle:(float)endAngle duration:(float)duration;

@end
