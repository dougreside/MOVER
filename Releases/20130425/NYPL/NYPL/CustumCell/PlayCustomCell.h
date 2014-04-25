//
//  PlayCustomCell.h
//  NYPL
//
//  Created by kiwitech on 26/10/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayCustomCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLable;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *authorLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;

@end
