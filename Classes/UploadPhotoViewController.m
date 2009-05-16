//
//  UploadPhotoViewController.m
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import "UploadData.h"
#import "AlbumModel.h"
#import "UploadPhotoRequest.h"

@implementation UploadPhotoViewController


@synthesize alertView;
@synthesize activityIndicatorView;
@synthesize imagePicker;
@synthesize uploadData;
@synthesize uploadPhotoRequest;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil uploadData:(UploadData *)inUploadData {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.uploadData = inUploadData;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[alertView release];
	[activityIndicatorView release];
	[imagePicker release];
	[uploadData release];
    [super dealloc];
}


- (IBAction)uploadFromCamera {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		NSLog(@"Camera supported");
		imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:imagePicker animated:YES];
	} else {
		NSLog(@"Camera is not supported");
	}
}


- (IBAction)uploadFromAlbum {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		NSLog(@"Album supported");
		imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:imagePicker animated:YES];
	} else {
		NSLog(@"Album is not supported");
	}
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	uploadData.image = image;
	[self dismissModalViewControllerAnimated:YES];

	//UI Activity Indicator with ActivityIndicator instead
	alertView = [ [UIAlertView alloc] initWithTitle:@"Please Wait" message:@"Sending Image" delegate:self cancelButtonTitle:nil otherButtonTitles: nil]; 
	//activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50.0f, 70.0f, 220.0f, 90.0f)]; 
	activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130.0f, 85.0f, 20.0f, 20.0f)]; 
	activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	[alertView addSubview:activityIndicatorView]; 
	[activityIndicatorView startAnimating]; 
	[alertView show];
	
	NSLog(@"Uploading Image");
	uploadPhotoRequest = [UploadPhotoRequest alloc];
	uploadPhotoRequest.delegate = self;
	[uploadPhotoRequest uploadPhoto:uploadData];
}


- (void)sendDataSuccessful {
	//To release activity sheet:
	[alertView dismissWithClickedButtonIndex:0 animated:YES];
	[activityIndicatorView stopAnimating];
	[alertView release];
	[activityIndicatorView release];
	
	NSLog(@"Upload Done");
}


- (void)sendDataError {
	NSLog(@"Send Data Error");
	[[[[UIAlertView alloc] autorelease] initWithTitle:@"ERROR" message:@"Error sending photo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


- (IBAction)viewAlbum {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:uploadData.album.url]];
}


@end
