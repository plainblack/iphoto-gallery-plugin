//
//  AddNewServerViewController.m
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AddNewServerViewController.h"
#import "SelectServerTableViewController.h"


@implementation AddNewServerViewController


@synthesize serverTextField;
@synthesize delegate;


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
	[serverTextField release];
	[delegate release];
    [super dealloc];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicatorView startAnimating];
	
	//Validate URL is capable of XML Services
	if ([self supportsWebServices:textField.text]) {
		[delegate addNewServer:textField.text];
		[textField resignFirstResponder];
		[self.navigationController popViewControllerAnimated:YES];
		[activityIndicatorView startAnimating];
		return YES;
	} else {
		//If not then validte if this is even a WebGUI site
		UIAlertView *openURLAlert;
		if ([self isOnNetwork]) {
			openURLAlert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"You do not have an active internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		}else if ([self isWebGui:textField.text]) {
			openURLAlert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"This WebGUI site does not support Web Services." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		} else {
			openURLAlert = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"This does not appear to be a valid WebGUI site." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		}
		[activityIndicatorView startAnimating];
		[openURLAlert show];
		[openURLAlert release];
		return NO;
	}
}


- (BOOL)isOnNetwork {
	
	//Request page
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:@"http://www.google.com"]];
	NSError *error;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	NSLog(@"Error: %@", error);
	[[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	return error != Nil;
}


- (BOOL)isWebGui:(NSString *)urlString {
	NSLog(@"WebGUI URL: %@", urlString);
	
	//Request page
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	NSError *error;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	NSLog(@"Error: %@", error);
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	return [returnString rangeOfString:@"<meta name=\"generator\" content=\"WebGUI"].location != NSNotFound;
}


- (BOOL)supportsWebServices:(NSString *)urlString {
	NSLog(@"WebGUI WebServices URL: %@", urlString);
	
	if ([urlString characterAtIndex:([urlString length]-1)] == '/') {
		urlString = [urlString stringByAppendingString:@"?op=findAssets;className=WebGUI::Asset::Wobject::Gallery;as=xml"];
	} else {
		urlString = [urlString stringByAppendingString:@"/?op=findAssets;className=WebGUI::Asset::Wobject::Gallery;as=xml"];
	}
	NSLog(@"WebGUI WebServices URL with params: %@", urlString);

	//Request page
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	return [returnString rangeOfString:@"<assets>"].location != NSNotFound;
}



@end
