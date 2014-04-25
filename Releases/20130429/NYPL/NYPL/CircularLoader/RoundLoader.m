//
//  RoundLoader.m
//  XMLParser
//
//  Created by Samar Gupta on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundLoader.h"
#import <QuartzCore/QuartzCore.h>

@interface RoundLoader ()

@end

@implementation RoundLoader
@synthesize radius;
@synthesize widthOfRadius;


- (void)startAnimation:(float)startAngle endAngle:(float)endAngle duration:(float)duration
{
	// Do any additional setup after loading the view.
    
    // Set up the shape of the circle
   
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(2.0*radius, 2.0*radius) radius:radius startAngle:startAngle endAngle:endAngle  clockwise:YES].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.frame)-2*radius, 
                                  CGRectGetMidY(self.frame)-2*radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor whiteColor].CGColor;
    circle.lineWidth = widthOfRadius;
    
//    //Add Shadow
//    circle.shadowColor = [UIColor darkGrayColor].CGColor;
//    circle.shadowOpacity = 1.0;
//    circle.shadowRadius = 5.0;
//    circle.shadowOffset = CGSizeMake(0, 2);
    
    // Add to parent layer
    [self.layer addSublayer:circle];
    // Set up the shape of the circle
    
    CAShapeLayer *shadow1 = [CAShapeLayer layer];
    // Make a circular shape
    shadow1.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(2.0*radius, 2.0*radius) radius:radius-4 startAngle:startAngle endAngle:endAngle clockwise:YES].CGPath;
    // Center the shape in self.view
    shadow1.position = CGPointMake(CGRectGetMidX(self.frame)-2*radius, 
                                  CGRectGetMidY(self.frame)-2*radius);
    
    // Configure the apperence of the circle
    shadow1.fillColor = [UIColor clearColor].CGColor;
    shadow1.strokeColor = [UIColor darkGrayColor].CGColor;
    shadow1.lineWidth = 1;
    // Add to parent layer
    [self.layer addSublayer:shadow1];
    // Set up the shape of the circle
    
    CAShapeLayer *shadow2 = [CAShapeLayer layer];
    // Make a circular shape
    shadow2.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(2.0*radius, 2.0*radius) radius:radius+4 startAngle:startAngle endAngle:endAngle  clockwise:YES].CGPath;
    // Center the shape in self.view
    shadow2.position = CGPointMake(CGRectGetMidX(self.frame)-2*radius, 
                                  CGRectGetMidY(self.frame)-2*radius);
    
    // Configure the apperence of the circle
    shadow2.fillColor = [UIColor clearColor].CGColor;
    shadow2.strokeColor = [UIColor grayColor].CGColor;
    shadow2.lineWidth = 0.5;
    
    // Add to parent layer
    [self.layer addSublayer:shadow2];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
