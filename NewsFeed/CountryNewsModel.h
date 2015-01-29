//
//  CountryNewsModel.h
//  NewsFeed
//
//  Created by Kartik Bohara on 29/01/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryNewsModel : NSObject

//Attributes defined in the JSON Feed
@property (nonatomic, strong)NSString *title;
@property (nonatomic,strong)NSString *description;
@property (nonatomic,strong)NSString *imageHref;
@property (nonatomic, strong) UIImage *cellImage;

@end
