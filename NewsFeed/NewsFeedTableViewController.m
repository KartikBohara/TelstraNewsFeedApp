//
//  NewsFeedTableViewController.m
//  NewsFeed
//
//  Created by Kartik Bohara on 29/01/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import "NewsFeedTableViewController.h"

#import "NewsFeedTableViewCell.h"
#import "CountryNewsModel.h"
#import "IconLoader.h"

static NSString * const kCellID = @"NewsFeedTableViewCell";

@interface NewsFeedTableViewController ()

@property (nonatomic,retain) UIRefreshControl *refreshControl;


@end

@implementation NewsFeedTableViewController

@synthesize activityIndicator;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.newsFeedModelArray = [[[NSMutableArray alloc] init] autorelease];
        self.imageDownloadsInProgress = [[[NSMutableDictionary alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.tableView setHidden:YES];
    
    //Initializing the activity indicator
    activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    activityIndicator.frame = CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2 - 10, 20, 20);
    [activityIndicator setOpaque:YES];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    //Initializing the Refresh Control 
    
    UIRefreshControl *refreshControl=[[UIRefreshControl alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100.0f)];
    self.refreshControl=refreshControl;
    [refreshControl release];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];

    //Fetching the data from Json Feed
    
    [self getJsonFromFeed];
}

// -------------------------------------------------------------------------------
//	function to refresh the tableview
// -------------------------------------------------------------------------------


-(void)refresh {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Json calls
// -------------------------------------------------------------------------------
//	function to get data from Json Feed asynchronously
// -------------------------------------------------------------------------------

-(void)getJsonFromFeed {
    
    NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/746330/facts.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark - NSURLConnectionDelegate

// -------------------------------------------------------------------------------
//	connection:didReceiveResponse:response
//  Called when enough data has been read to construct an NSURLResponse object.
// -------------------------------------------------------------------------------

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.newsListData = [NSMutableData data];    // start off with new data
}

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
//  Called with a single immutable NSData object to the delegate, representing the next
//  portion of the data loaded from the connection.
// -------------------------------------------------------------------------------

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.newsListData appendData:data];  // append incoming data
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
//  Will be called at most once, if an error occurs during a resource load.
//  No other callbacks will be made after.
// -------------------------------------------------------------------------------

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (error.code == kCFURLErrorNotConnectedToInternet)
	{
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"No Connection Error"};
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
        [self handleError:noConnectionError];
    }
	else
	{
        // otherwise handle the error generically
        [self handleError:error];
    }
    
    
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
//  Called when all connection processing has completed successfully, before the delegate
//  is released by the connection.
// -------------------------------------------------------------------------------

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError* error = nil;
    NSString *jsonString = [[[NSString alloc] initWithData:self.newsListData encoding:NSISOLatin1StringEncoding]autorelease ];
    NSArray *rows = nil;
    
    if (jsonString) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:
                                      [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]
                                                                     options:0 error:&error];
        
        self.navigationItem.title = [responseDict objectForKey:@"title"];
        
        rows = [responseDict objectForKey:@"rows"];
        
        
    }
    
    //extracting data
    for (int i = 0; i<rows.count; i++) {
        NSDictionary *detailDictionary = [rows objectAtIndex:i];
        
        CountryNewsModel *newsModel = [[[CountryNewsModel alloc]init] autorelease];
        if(![[detailDictionary objectForKey:@"title"] isKindOfClass:[NSNull class]])
            newsModel.title = [NSString stringWithFormat:@"%@", [detailDictionary objectForKey:@"title"]];
        if(![[detailDictionary objectForKey:@"description"] isKindOfClass:[NSNull class]])
        {
            newsModel.description = [NSString stringWithFormat:@"%@", [detailDictionary objectForKey:@"description"]];
        }
        newsModel.imageHref = [detailDictionary objectForKey:@"imageHref"];
        if(!(newsModel.imageHref== (id)[NSNull null] || newsModel.imageHref.length == 0 ) || !(newsModel.title == (id)[NSNull null] || newsModel.title.length == 0 ) || !(newsModel.description == (id)[NSNull null] || newsModel.description.length == 0 )){
            
            [self.newsFeedModelArray addObject:newsModel];
        }
        
        
    }
    
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    // ownership of appListData has been transferred to the parse operation
    // and should no longer be referenced in this thread
    self.newsListData = nil;
}

- (void)handleError:(NSError *)error
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error"
														message:@"Not able to connect to network. Please check your network and try again"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [activityIndicator stopAnimating];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsFeedModelArray count];
    //    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return [self heightForBasicCellAtIndexPath:indexPath];
    
    CountryNewsModel *countryModel = [self.newsFeedModelArray objectAtIndex:indexPath.row];
    CGSize maximumLabelSize = CGSizeMake(tableView.frame.size.width,400);
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    CGSize expectedLabelSize = CGSizeMake(0, 0);
    CGSize expectedAnotherSize =  CGSizeMake(0, 0);
    
    //Get the title height
    if(!(countryModel.title == (id)[NSNull null] || countryModel.title.length == 0 )){
        expectedLabelSize = [countryModel.title sizeWithFont:font
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    maximumLabelSize = CGSizeMake(200,400);
    
    //Get the description height
    if(!(countryModel.description == (id)[NSNull null] || countryModel.description.length == 0 )){
        
        expectedAnotherSize =[countryModel.description sizeWithFont:font
                                                  constrainedToSize:maximumLabelSize
                                                      lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    //Business Logic to Calculate height of the cell
    float totalHeight = expectedAnotherSize.height + expectedLabelSize.height+30.0f;
    
    if(totalHeight <=110.0){
        if((!(countryModel.imageHref == (id)[NSNull null] || countryModel.imageHref.length == 0 )))
            totalHeight =  150.0f;
    }
    
    return totalHeight;
    
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsFeedTableViewCell *sizingCell = [self basicCellAtIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(NewsFeedTableViewCell *)sizingCell {
    
    [sizingCell setFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(sizingCell.bounds))];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (NewsFeedTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsFeedTableViewCell *cell = (NewsFeedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    return cell ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID] ;
    if (!cell) {
        cell = [[[NewsFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID] autorelease];
    }

    
    CountryNewsModel *newsModel = [self.newsFeedModelArray objectAtIndex:indexPath.row];
    if (newsModel) {
        
        if(newsModel.title)
        {
            //NSLog(@"%@",newsModel.title);
            [cell.newsTitleLabel setText:newsModel.title];
            
        }
        if(newsModel.description)
        {
            //NSLog(@"%@",newsModel.description);
            [cell.newsDescLabel setText:newsModel.description];
            
        }
        
        if(!(newsModel.imageHref == (id)[NSNull null] || newsModel.imageHref.length == 0 )){
            
            
            if (!newsModel.cellImage)
            {
                if (tableView.dragging == NO && tableView.decelerating == NO)
                {
                    [self startIconDownload:newsModel forIndexPath:indexPath];
                }
                // If a download is deferred or in progress, return the placeholder image
                cell.newsImage.image = [UIImage imageNamed:@"Placeholder.png"];
            }
            else
            {
                cell.newsImage.image = newsModel.cellImage;
            }
            
        }
    }
      [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)startIconDownload:(CountryNewsModel *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconLoader *imageloader = (self.imageDownloadsInProgress)[indexPath];
    if (imageloader == nil)
    {
        imageloader = [[IconLoader alloc] init];
        imageloader.appRecord = appRecord;
        [imageloader setCompletionHandler:^{
            
            NewsFeedTableViewCell *cell = (NewsFeedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.newsImage.image = appRecord.cellImage;
            
            // Remove the imageDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = imageloader;
        [imageloader startDownload];
    }
}

-(void) dealloc {
    
    //[self.newsFeedModelArray release];
    self.newsFeedModelArray = nil;
    
    //[self.imageDownloadsInProgress release];
    self.imageDownloadsInProgress = nil;
    
    [super dealloc];
}


@end
