//
//  SelectServerTableViewController.m
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SelectServerTableViewController.h"
#import "AddNewServerViewController.h"
#import "LoginViewController.h"
#import "InfoViewController.h"


@implementation SelectServerTableViewController


@synthesize servers;
@synthesize serverFilePath;


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex:0];
	self.serverFilePath = [documentFolderPath stringByAppendingPathComponent:@"servers.plist"];
	[self loadServers];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [servers count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ServerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    // Configure the cell
	if (indexPath.row == [servers count]) {
		cell.text = @"Add server";
	} else {
		cell.text = [servers objectAtIndex:indexPath.row];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == [servers count]) {
		[self showAdd];
	} else {
		NSLog(@"Do login for %@", [servers objectAtIndex:indexPath.row]);
		[self showLogin: [servers objectAtIndex:indexPath.row]];
	}

	[tableView deselectRowAtIndexPath:indexPath	animated:NO];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView beginUpdates];
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[servers removeObjectAtIndex:indexPath.row];
	}
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		
	}
	[tableView endUpdates];
	[self saveServers];
}

 
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.row < [servers count];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[servers dealloc];
	[serverFilePath dealloc];
    [super dealloc];
}


- (void)addNewServer:(NSString *)serverUrl {
	NSLog(@"Add server called");
	NSLog(@"Add server: %@", serverUrl);

    [self.tableView beginUpdates];
	[servers addObject:serverUrl];
	NSIndexPath *indexPath;
	indexPath = [NSIndexPath indexPathForRow:[servers indexOfObject:serverUrl] inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
	[self.tableView endUpdates];
	[self saveServers];
}


- (void)loadServers {
	NSLog(@"Load Servers");

	if ([[NSFileManager defaultManager] fileExistsAtPath:serverFilePath]) {
		NSLog(@"File exists");
		NSData *serverData = [NSData dataWithContentsOfFile:serverFilePath];
		NSString *errorString;
		self.servers = [NSPropertyListSerialization propertyListFromData:serverData mutabilityOption:NSPropertyListMutableContainers format:nil errorDescription:&errorString];
		if (errorString != nil) {
			NSLog(@"Error loading servers: %@", errorString);
		}
	} else {
		NSLog(@"File does NOT exists");
		self.servers = [NSMutableArray arrayWithObjects: @"http://www.webgui.org", nil];
	}
}


- (void)saveServers{
	NSLog(@"Save Servers");
	NSString *errorString;
	NSData *serverData = [NSPropertyListSerialization dataFromPropertyList:servers format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
	[serverData writeToFile:serverFilePath atomically:YES];
	if (errorString != nil) {
		NSLog(@"Error saving servers: %@", errorString);
	}
}


- (void)showAdd {
	NSLog(@"Go To Add Server");
	AddNewServerViewController *addNewServerViewController;
	addNewServerViewController = [[AddNewServerViewController alloc] initWithNibName:@"AddNewServerViewController" bundle:nil];
	addNewServerViewController.delegate = self;
	[self.navigationController pushViewController:addNewServerViewController animated:YES];
	// KEVIN Why does this blow up when I do this in a sub method
	//[addNewServerViewController release];
}

- (void)showLogin:(NSString *) serverUrl {
	//Go to Login screen
	LoginViewController *loginViewController;
	loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil serverUrl:serverUrl];
	[self.navigationController pushViewController:loginViewController animated:YES];
	[loginViewController release];
}


- (IBAction)showInfo {
	//Go to Info screen
	InfoViewController * infoViewController;
	infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
	[self.navigationController pushViewController:infoViewController animated:YES];
	[infoViewController release];
}

@end

