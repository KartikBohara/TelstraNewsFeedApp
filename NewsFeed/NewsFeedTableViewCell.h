//
//  NewsFeedTableViewCell.h
//  NewsFeed
//
//  Created by Kartik Bohara on 29/01/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *newsTitleLabel;
@property (nonatomic, strong) UILabel *newsDescLabel;
@property (nonatomic, strong) UIImageView *newsImage;

@end

