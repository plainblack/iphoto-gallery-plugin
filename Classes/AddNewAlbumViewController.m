//
//  AddNewAlbumViewController.m
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AddNewAlbumViewController.h"
#import "UploadData.h"
#import "GalleryModel.h"
#import	"SelectAlbumTableViewController.h"


@implementation AddNewAlbumViewController


@synthesize uploadData;
@synthesize selectAlbumtTableViewController;
@synthesize serverTextField;


/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	[serverTextField becomeFirstResponder];
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
	[uploadData release];
	[serverTextField release];
    [super dealloc];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// KEVIN Send Create Album Request her
	NSLog(@"Adding %@ to %@", textField.text, uploadData.gallery.url);
	[textField resignFirstResponder];
	
	NSString *urlString;
	if ([uploadData.gallery.url characterAtIndex:([uploadData.gallery.url length]-1)] == '/') {
		urlString = [[NSString alloc] initWithFormat: @"%@", uploadData.gallery.url ];
	} else {
		urlString = [[NSString alloc] initWithFormat: @"%@%@", uploadData.gallery.url, @"/" ];
	}
	
	//Create the request
	NSURL *requestUrl = [NSURL URLWithString:urlString];
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:requestUrl];

	//setting the headers:
	[postRequest setHTTPMethod:@"POST"];
	if (uploadData.authEncoding != NULL) {
		NSLog(@"Using Authorization: %@", uploadData.authEncoding);
		[postRequest addValue:uploadData.authEncoding forHTTPHeaderField:@"Authorization"];
	}
	NSString *boundary = [NSString stringWithString:@"------------0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];

	//Create Post Body
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"func\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"addAlbumService"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"as\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"xml"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:textField.text] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postRequest setHTTPBody:postBody];
	
	NSLog([[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding]);
	
	//Send Request
	NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(returnString);
	
	[self.selectAlbumtTableViewController refreshData];
	
	[self.navigationController popViewControllerAnimated:YES];
	return YES;
}


@end
