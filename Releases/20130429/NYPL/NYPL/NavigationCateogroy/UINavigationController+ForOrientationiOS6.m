//
//  UINavigationController+ForOrientationiOS6.m
//  Elsevier
//
//  Created by kiwitech on 25/09/12.
//
//

#import "UINavigationController+ForOrientationiOS6.h"

@implementation UINavigationController (ForOrientationiOS6)

-(BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (void)viewWillAppear:(BOOL)animated{
}

@end
