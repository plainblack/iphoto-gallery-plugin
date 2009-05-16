//
//  LoginViewController.m
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "Base64.h"
#import "UploadData.h"
#import "SelectGalleryTableViewController.h"


@implementation LoginViewController


@synthesize password;
@synthesize username;
@synthesize uploadData;
@synthesize usernameByHost;
@synthesize usernameByHostFilePath;


- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle serverUrl:(NSString *)serverUrl {
	[super initWithNibName:nibName bundle:nibBundle];
	uploadData = [UploadData alloc];
	uploadData.serverUrl = serverUrl;
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex:0];
	self.usernameByHostFilePath = [documentFolderPath stringByAppendingPathComponent:@"usernames.plist"];
	[self loadUsernames];
	NSString *lastUsername = [self.usernameByHost objectForKey:self.uploadData.serverUrl];
	if (lastUsername != nil) {
		username.text = lastUsername;
	}
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
	[password release];
	[username release];
	[uploadData release];
	[usernameByHost release];
	[usernameByHostFilePath release];
    [super dealloc];
}


-(void)doLogin {
	NSLog(@"Login was hit");
	
	//Build Auth Encoding String
	NSString *tmp = [NSString stringWithFormat:@"%@:%@", self.username.text, self.password.text];
	NSString *encoded = [Base64 encodeString:tmp];
	self.uploadData.authEncoding = [NSString stringWithFormat:@"Basic %@", encoded];
	NSLog(@"Auth String is: %@", self.uploadData.authEncoding);
	[self.usernameByHost setValue:self.username.text forKey:self.uploadData.serverUrl];
	[self saveUsernames];
	
	//Go to album select screen
	SelectGalleryTableViewController *selectGalleryTableViewController;
	selectGalleryTableViewController = [[SelectGalleryTableViewController alloc] initWithNibName:@"SelectGalleryTableViewController" bundle:nil];
	selectGalleryTableViewController.uploadData = uploadData;
	[self.navigationController pushViewController:selectGalleryTableViewController animated:YES];
	[selectGalleryTableViewController release];
}


- (void)loadUsernames {
	NSLog(@"Load Usernames");
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:usernameByHostFilePath]) {
		NSLog(@"File exists");
		NSData *usernameData = [NSData dataWithContentsOfFile:usernameByHostFilePath];
		NSString *errorString;
		self.usernameByHost = [NSPropertyListSerialization propertyListFromData:usernameData mutabilityOption:NSPropertyListMutableContainers format:nil errorDescription:&errorString];
		if (errorString != nil) {
			NSLog(@"Error loading usernames: %@", errorString);
		}
	} else {
		NSLog(@"Username By Host File does NOT exists");
		self.usernameByHost = [[NSMutableDictionary alloc] init];
	}
}


- (void)saveUsernames{
	NSLog(@"Save Usernames");
	NSString *errorString;
	NSData *usernameData = [NSPropertyListSerialization dataFromPropertyList:usernameByHost format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
	[usernameData writeToFile:usernameByHostFilePath atomically:YES];
	if (errorString != nil) {
		NSLog(@"Error saving usernames: %@", errorString);
	}
}


@end
