//
//  SelectAlbumTableViewController.m
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SelectAlbumTableViewController.h"
#import "AddNewAlbumViewController.h"
#import	"UploadData.h"
#import "GalleryModel.h"
#import	"AlbumModel.h"
#import "AlbumRequest.h"
#import "UploadPhotoViewController.h"


@implementation SelectAlbumTableViewController


@synthesize albums;
@synthesize alertView;
@synthesize activityIndicatorView;
@synthesize uploadData;


- (void)viewDidLoad {
    [super viewDidLoad];
	self.albums = [[NSMutableArray alloc] initWithCapacity:10];	
	[self refreshData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [albums count] + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AlbumCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    // Configure the cell
	if ([albums count] == indexPath.row)  {
		cell.text = @"Create new Album";
	} else if ([albums count] + 1 == indexPath.row)  {
		cell.text = @"View Gallery";
	} else {
		AlbumModel *album = [albums objectAtIndex:indexPath.row];
		cell.text = album.title;
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([albums count] == indexPath.row)  {
		NSLog(@"Add new Album to %@", uploadData.gallery.url);
		
		//Allow user to create new Album
		AddNewAlbumViewController *addNewAlbumViewController;
		addNewAlbumViewController = [[AddNewAlbumViewController alloc] initWithNibName:@"AddNewAlbumViewController" bundle:nil];
		addNewAlbumViewController.uploadData = uploadData;
		addNewAlbumViewController.selectAlbumtTableViewController = self;
		[self.navigationController pushViewController:addNewAlbumViewController animated:YES];
		[addNewAlbumViewController release];
	} else if ([albums count] + 1 == indexPath.row)  {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:uploadData.gallery.url]];
	} else {
		NSLog(@"Pick Photo");
		
		//Set Album
		uploadData.album = [self.albums objectAtIndex:indexPath.row];
		
		//Allow user to upload photos
		UploadPhotoViewController *uploadPhotoViewController;
		uploadPhotoViewController = [[UploadPhotoViewController alloc] initWithNibName:@"UploadPhotoViewController" bundle:nil uploadData:uploadData];
		[self.navigationController pushViewController:uploadPhotoViewController animated:YES];
		[uploadPhotoViewController release];
	}
	[tableView deselectRowAtIndexPath:indexPath	animated:NO];
}


- (void)dealloc {
	[albums release];
	[alertView release];
	[activityIndicatorView release];
	[uploadData release];
    [super dealloc];
}


- (void)refreshData {
	[self.albums removeAllObjects];
	[[AlbumRequest alloc] albumsForGallery:uploadData.gallery.url withAuth:uploadData.authEncoding into:self.albums withDelegate:self];
	[self.tableView reloadData];
	
	//UI Activity Indicator with ActivityIndicator instead
	alertView = [ [UIAlertView alloc] initWithTitle:@"Please Wait" message:@"Requesting Galleries" delegate:self cancelButtonTitle:nil otherButtonTitles: nil]; 
	activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130.0f, 85.0f, 20.0f, 20.0f)]; 
	activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	[alertView addSubview:activityIndicatorView]; 
	[activityIndicatorView startAnimating]; 
	[alertView show];
}


- (void)requestDataError {
	NSLog(@"Error getting Albums");
	//To release activity sheet:
	[alertView dismissWithClickedButtonIndex:0 animated:YES];
	[activityIndicatorView stopAnimating];
	[alertView release];
	[activityIndicatorView release];
	[[[[UIAlertView alloc] autorelease] initWithTitle:@"ERROR" message:@"Error receiving Albums" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


- (void)requestDataSuccessful {
	NSLog(@"Got Albums need to update table");
	//To release activity sheet:
	[alertView dismissWithClickedButtonIndex:0 animated:YES];
	[activityIndicatorView stopAnimating];
	[alertView release];
	[activityIndicatorView release];
	[self.tableView reloadData];
}


@end

