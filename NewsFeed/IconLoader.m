//
//  IconLoader.m
//  NewsFeed
//
//  Created by Kartik Bohara on 29/01/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//


#import "IconLoader.h"
#define kAppIconWidth 85
#define kAppIconHeight 100



#pragma mark -

@implementation IconLoader
{
    NSURLConnection *conn;
}
@synthesize appRecord, activeDownload;

// -------------------------------------------------------------------------------
//	function to start Download of Image files asynchronously
// -------------------------------------------------------------------------------
- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.appRecord.imageHref]];
    
    // allocating & initialising the connection; release on completion/failure
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
//    imageConnection = conn;
//    [conn release];
}

// -------------------------------------------------------------------------------
//	function to cancel the Download
// -------------------------------------------------------------------------------
- (void)cancelDownload
{
    
    [conn cancel];
    [conn release];
    conn = nil;
    self.activeDownload = nil;
}

-(void)dealloc{
    
    [activeDownload release];
    self.activeDownload = nil;
    
    [super dealloc];
}


#pragma mark - NSURLConnectionDelegate

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    [conn release];
    conn = nil;
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[[UIImage alloc] initWithData:self.activeDownload] autorelease];
    
    //check if images are of correct size before setting to records
    if (image.size.width != kAppIconWidth || image.size.height != kAppIconHeight)
	{
        CGSize itemSize = CGSizeMake(kAppIconWidth, kAppIconHeight);
		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.appRecord.cellImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.appRecord.cellImage = image;
    }
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
    {
        self.completionHandler();
    }
    [conn release];
    conn = nil;
}



@end

