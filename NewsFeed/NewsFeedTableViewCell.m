//
//  NewsFeedTableViewCell.m
//  NewsFeed
//
//  Created by Kartik Bohara on 29/01/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import "NewsFeedTableViewCell.h"

@implementation NewsFeedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        self.newsTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 30)] autorelease];

        [self.newsTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.newsTitleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [self.newsTitleLabel setTextColor:[UIColor colorWithRed:(32/255.f) green:(55/255.f) blue:(117/255.f) alpha:1.0f]];
        [self.contentView addSubview:self.newsTitleLabel];
        
        self.newsDescLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 50, 200, 130)] autorelease];
       
        [self.newsDescLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
        [self.newsDescLabel setTextColor:[UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0f]];
        [self.newsDescLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.newsDescLabel setNumberOfLines:500];
        [self.contentView addSubview:self.newsDescLabel];
        
        self.newsImage = [[[UIImageView alloc]initWithFrame:CGRectMake(200, 35, 85, 100)] autorelease];
        [self.newsImage setImage:[UIImage imageNamed:@"Placeholder.png"]];
        [self.contentView addSubview:self.newsImage];
        
        
        
        
    }
    [self addconstrainsForCellElements];
    return self;
}

-(void)addconstrainsForCellElements
{
    [self.newsTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.newsDescLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.newsImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Adding 'Leading' , 'Trailing' , 'Top' constraints for Title Label
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsTitleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
    NSLayoutConstraint *topConstraintForTitleLabel =[NSLayoutConstraint constraintWithItem:self.newsTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    [topConstraintForTitleLabel setPriority:UILayoutPriorityRequired]; // Setting maximum priority for the constraint
    [self.contentView addConstraint:topConstraintForTitleLabel];
    
    
    // Adding 'Leading' , 'Bottom' constraints to Description Label
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsDescLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.newsTitleLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    NSLayoutConstraint *bottomConstraintForDescLabel = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.newsDescLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    [bottomConstraintForDescLabel setPriority:900];
    [self.contentView addConstraint:bottomConstraintForDescLabel];
    
    // Addding Cross Contraint between Title label and desc label
    NSLayoutConstraint *topConstraintForDescLabel=[NSLayoutConstraint constraintWithItem:self.newsDescLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.newsTitleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    [topConstraintForDescLabel setPriority:UILayoutPriorityRequired];
    [self.contentView addConstraint:topConstraintForDescLabel];
    
    
    // Adding 'Centre Y ' , 'Leading' , 'Bottom' constraints to Feed ImageView
    
    NSLayoutConstraint *centreSpacingConstraint=[NSLayoutConstraint constraintWithItem:self.newsImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [centreSpacingConstraint setPriority:900];
    [self.contentView addConstraint:centreSpacingConstraint];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.newsImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.newsDescLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.newsImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
    
    NSLayoutConstraint *constraintForImageViewBottom=[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.newsImage attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    [constraintForImageViewBottom setPriority:900]; // Setting a lower priority constraint to acheive a gap of 10 pixel between the imageview and bottom of the contentview
    [self.contentView addConstraint:constraintForImageViewBottom];
    
    NSLayoutConstraint *topSpacingCOnstraintImgView=[NSLayoutConstraint constraintWithItem:self.newsImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.newsDescLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [topSpacingCOnstraintImgView setPriority:900];
    [self.contentView addConstraint:topSpacingCOnstraintImgView];
    
    
    // Setting the Height and Width for the ImageView.
    NSDictionary *dictionary=NSDictionaryOfVariableBindings(_newsImage,_newsTitleLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_newsImage(70)]" options:0 metrics:nil views:dictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_newsImage(50)]" options:0 metrics:nil views:dictionary]];
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
