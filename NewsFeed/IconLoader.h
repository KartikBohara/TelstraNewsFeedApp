//
//  IconLoader.h
//  NewsFeed
//
//  Created by Kartik Bohara on 29/01/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountryNewsModel.h"

@interface IconLoader : NSObject


@property (nonatomic, strong) CountryNewsModel *appRecord;
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end