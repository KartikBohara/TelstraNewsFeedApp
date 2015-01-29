//
//  NewsFeedTableViewController.h
//  NewsFeed
//
//  Created by Kartik Bohara on 29/01/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *newsFeedModelArray;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,strong) NSMutableData *newsListData;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


@end
