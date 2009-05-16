//
//  SelectGalleryTableViewController.m
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SelectGalleryTableViewController.h"
#import "SelectAlbumTableViewController.h"
#import "UploadData.h"
#import "GalleryModel.h"
#import "GalleryRequest.h"


@implementation SelectGalleryTableViewController


@synthesize alertView;
@synthesize activityIndicatorView;
@synthesize uploadData;
@synthesize galleries;


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	galleries = [[NSMutableArray alloc] initWithCapacity:10];
	[[GalleryRequest alloc] galleriesForServer:uploadData.serverUrl withAuth:uploadData.authEncoding into:self.galleries withDelegate:self];

	//UI Activity Indicator with ActivityIndicator instead
	alertView = [ [UIAlertView alloc] initWithTitle:@"Please Wait" message:@"Requesting Galleries" delegate:self cancelButtonTitle:nil otherButtonTitles: nil]; 
	activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130.0f, 85.0f, 20.0f, 20.0f)]; 
	activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	[alertView addSubview:activityIndicatorView]; 
	[activityIndicatorView startAnimating]; 
	[alertView show];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [galleries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"GalleryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Configure the cell
	GalleryModel *gallery = [galleries objectAtIndex:indexPath.row];
	cell.text = gallery.title;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//Go to album select screen
	SelectAlbumTableViewController *selectAlbumTableViewController;
	selectAlbumTableViewController = [[SelectAlbumTableViewController alloc] initWithNibName:@"SelectAlbumTableViewController" bundle:nil];
	uploadData.gallery = [self.galleries objectAtIndex:indexPath.row];
	selectAlbumTableViewController.uploadData = uploadData;
	[self.navigationController pushViewController:selectAlbumTableViewController animated:YES];
	[selectAlbumTableViewController release];
	[tableView deselectRowAtIndexPath:indexPath	animated:NO];
}


- (void)dealloc {
	[alertView release];
	[activityIndicatorView release];
	[galleries release];
	[uploadData release];
    [super dealloc];
}


- (void)requestDataError {
	NSLog(@"Error getting Galleries");
	//To release activity sheet:
	[alertView dismissWithClickedButtonIndex:0 animated:YES];
	[activityIndicatorView stopAnimating];
	[alertView release];
	[activityIndicatorView release];
	[[[[UIAlertView alloc] autorelease] initWithTitle:@"ERROR" message:@"Error receiving Galleries" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


- (void)requestDataSuccessful {
	NSLog(@"Got Galleries need to update table");
	//To release activity sheet:
	[alertView dismissWithClickedButtonIndex:0 animated:YES];
	[activityIndicatorView stopAnimating];
	[alertView release];
	[activityIndicatorView release];
	[self.tableView reloadData];
}


@end

