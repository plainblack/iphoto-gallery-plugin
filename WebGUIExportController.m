//
//  WebGUIExportController.m
//  WebGUIiPhoto
//
//  Created by Kevin Runde on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WebGUIExportController.h"
#import "AuthCoder.h"
#import "AlbumModel.h"
#import "AlbumRequest.h"
#import "GalleryModel.h"
#import "GalleryRequest.h"
#import "UploadData.h"
#import "UploadPhotoRequest.h"
#import "NewAlbumRequest.h"


@implementation WebGUIExportController


@synthesize settingsBox;
@synthesize firstView;
@synthesize serverComboBox;
@synthesize usernameField;
@synthesize passwordField;
@synthesize galleryPopUpButton;
@synthesize albumPopUpButton;
@synthesize waitWindow;
@synthesize waitIndicator;
@synthesize newAlbumWindow;
@synthesize newAlbumTextField;
@synthesize albums;
@synthesize albumRequest;
@synthesize galleries;
@synthesize galleryRequest;
@synthesize serverFile;
@synthesize servers;
@synthesize serverToUsernameFile;
@synthesize serverToUsernames;
@synthesize uploadData;


- (void)awakeFromNib {
	self.uploadData = [[UploadData alloc] init];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *serverFileDir = [self.serverFile stringByDeletingLastPathComponent];
	if (![fileManager fileExistsAtPath:serverFileDir]) {
		[fileManager createDirectoryAtPath:serverFileDir withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	[self loadServers];
	[self loadUsernames];
}


- (id)initWithExportImageObj:(id <ExportImageProtocol>)obj {
	if (self == [super init]) {
		exportManager = obj;
		exportProgress.message = nil;
		exportLock = [[NSLock alloc] init];
		self.albums = [[NSMutableArray alloc] initWithCapacity:100];
		self.galleries = [[NSMutableArray alloc] initWithCapacity:100];
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString *userLibFolderPath = [searchPaths objectAtIndex:0];
		self.serverFile = [[userLibFolderPath stringByAppendingPathComponent:@"Application Support/iPhoto/Plugins/WebGUIiPhoto.iPhotoExporter/servers.plist"] retain];
		self.serverToUsernameFile = [[userLibFolderPath stringByAppendingPathComponent:@"Application Support/iPhoto/Plugins/WebGUIiPhoto.iPhotoExporter/usernames.plist"] retain];
	}
	
	return self;
}


- (void)controlTextDidBeginEditing:(NSNotification *)aNotification {
	//Called when the text of the Server Combo Box begins being edited.
	[albumPopUpButton setEnabled:NO];
	[galleryPopUpButton setEnabled:NO];
	
	[albumPopUpButton removeAllItems];
	albumPopUpButton.stringValue = @"";
	[albums removeAllObjects];
	[galleryPopUpButton removeAllItems];
	[galleries removeAllObjects];
}


- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
	//This is called when the Sever Combo Box selected item changes. It does not tell us if the user entered a new name though.
	
	//Clear out existing Gallery and Album Data
	[albumPopUpButton setEnabled:NO];
	[galleryPopUpButton setEnabled:NO];
	
	[albumPopUpButton removeAllItems];
	[albums removeAllObjects];
	albumPopUpButton.stringValue = @"";
	[galleryPopUpButton removeAllItems];
	[galleries removeAllObjects];

	//Look up username and set the username and password fields.
	NSString *username = [serverToUsernames objectForKey:[serverComboBox objectValueOfSelectedItem]];
	if (username) {
		usernameField.stringValue = username;
	} else {
		usernameField.stringValue = @"";
	}
	passwordField.stringValue = @"";
}


- (void)dealloc {
	[settingsBox release];
	[firstView release];
	[serverComboBox release];
	[usernameField release];
	[passwordField release];
	[galleryPopUpButton release];
	[albumPopUpButton release];
	[albums release];
	[albumRequest release];
	[galleries release];
	[galleryRequest release];
	[servers release];
	[serverFile release];
	[exportLock release];
	[uploadData release];
	[super dealloc];
}


- (IBAction)fetchAlbums:(id)sender {
	//Clean up existing data
	[albumPopUpButton setEnabled:NO];
	[albumPopUpButton removeAllItems];
	albumPopUpButton.stringValue = @"";
	[albums removeAllObjects];
	
	//Find selected data
	int idx = [galleryPopUpButton indexOfSelectedItem]-1;
	if (idx >= 0) {
		//Show please wait
		[NSApp beginSheet:waitWindow modalForWindow:settingsBox.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
		[waitIndicator startAnimation:nil];
		
		//Get gallery to look up albums for
		uploadData.gallery = [galleries objectAtIndex:idx];

		//Request new album list
		self.albumRequest = [[AlbumRequest alloc] init];
		[albumRequest albumsForGallery:uploadData.gallery.url withAuth:uploadData.authEncoding into:albums withDelegate:self];
	}
}


- (IBAction)fetchGalleries:(id)sender {
	//Clear out the Album and Gallery Data
	[albumPopUpButton setEnabled:NO];
	[galleryPopUpButton setEnabled:NO];
	
	[albumPopUpButton removeAllItems];
	albumPopUpButton.stringValue = @"";
	[albums removeAllObjects];
	[galleryPopUpButton removeAllItems];
	[galleries removeAllObjects];
	self.albumRequest = nil;
	
	//If a new server store it
	if ([serverComboBox indexOfSelectedItem] == -1) {
		//Store usernamd and password so we can restore them because the selectItemWithObjectValue call will cause them to be cleared
		NSString *username = usernameField.stringValue;
		NSString *password = passwordField.stringValue;

		//Get value save it and ensure it is selected in the list.
		[servers addObject:serverComboBox.stringValue];
		[serverComboBox addItemWithObjectValue:serverComboBox.stringValue];
		[serverComboBox selectItemWithObjectValue:serverComboBox.stringValue];
		
		//Resture username and password since they were just cleared
		usernameField.stringValue = username;
		passwordField.stringValue = password;
		[self saveServers];
	}

	//Store username used
	[serverToUsernames setObject:usernameField.stringValue forKey:serverComboBox.stringValue];
	[self saveUsernames];
	
	//Set server url
	uploadData.serverUrl = serverComboBox.stringValue;

	//Set auth encoding
	NSString *tmp = [[NSString stringWithFormat:@"%@:%@", usernameField.stringValue, passwordField.stringValue] retain];
	NSString *encoded = [AuthCoder encodeUsername:usernameField.stringValue password:passwordField.stringValue];
	if (encoded) { 
		self.uploadData.authEncoding = [NSString stringWithFormat:@"Basic %@", encoded];
	} else {
		self.uploadData.authEncoding = nil;
	}

	//Show please wait
	[NSApp beginSheet:waitWindow modalForWindow:settingsBox.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
	[waitIndicator startAnimation:nil];

	//Send request
	self.galleryRequest = [[GalleryRequest alloc] init];
	[galleryRequest galleriesForServer:uploadData.serverUrl	withAuth:uploadData.authEncoding into:galleries withDelegate:self];
	[tmp release];
}


- (IBAction)viewServer:(id)sender {
	NSURL *url = [NSURL URLWithString:serverComboBox.stringValue];
	[[NSWorkspace sharedWorkspace] openURL:url];
}


- (IBAction)removeServer:(id)sender {
	int idx = [serverComboBox indexOfSelectedItem];
	if (idx >= 0) {
		NSString *serverUrl = [servers objectAtIndex:idx];
		[serverComboBox removeItemAtIndex:idx];
		serverComboBox.stringValue = @"";
		[servers removeObjectAtIndex:idx];
		[serverToUsernames removeObjectForKey:serverUrl];
		[self saveServers];
		[self saveUsernames];
	}
}


- (IBAction)viewGallery:(id)sender {
	int idx = [galleryPopUpButton indexOfSelectedItem] - 1;
	if (idx >= 0) {
		GalleryModel *gallery = [galleries objectAtIndex:idx];
		NSURL *url = [NSURL URLWithString:gallery.url];
		[[NSWorkspace sharedWorkspace] openURL:url];
	}
}


- (IBAction)viewAlbum:(id)sender {
	int idx = [albumPopUpButton indexOfSelectedItem] - 1;
	if (idx >= 0) {
		AlbumModel *album = [albums objectAtIndex:idx];
		NSURL *url = [NSURL URLWithString:album.url];
		[[NSWorkspace sharedWorkspace] openURL:url];
	}
}


- (IBAction)showNewAlbum:(id)sender {
	newAlbumTextField.stringValue = @"";
	[NSApp beginSheet:newAlbumWindow modalForWindow:settingsBox.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
}


- (IBAction)createNewAlbum:(id)sender {
	int galleryIdx = [galleryPopUpButton indexOfSelectedItem]-1;
	if (galleryIdx >= 0) {
		GalleryModel *gallery = [galleries objectAtIndex:galleryIdx];
		[NSApp endSheet:newAlbumWindow];
		[newAlbumWindow orderOut:self];
		NewAlbumRequest *request = [[NewAlbumRequest alloc] init];
		[request createAlbum:newAlbumTextField.stringValue forGallery:gallery withAuthEncoding:uploadData.authEncoding];
		[request release];
		[self fetchAlbums:sender];
		[albumPopUpButton selectItemWithTitle:newAlbumTextField.stringValue];
	}
}


- (IBAction)cancelNewAlbum:(id)sender{
	[NSApp endSheet:newAlbumWindow];
	[newAlbumWindow orderOut:self];
}


- (void)loadServers {
	if ([[NSFileManager defaultManager] fileExistsAtPath:serverFile]) {
		NSData *serverData = [NSData dataWithContentsOfFile:serverFile];
		NSString *errorString;
		self.servers = [NSPropertyListSerialization propertyListFromData:serverData mutabilityOption:NSPropertyListMutableContainers format:nil errorDescription:&errorString];
		if (errorString != nil) {
			NSRunAlertPanel(@"WebGUI Exporter", [NSString stringWithFormat:@"Error reading server file: %@", errorString], @"OK", nil, nil);
		}
	} else {
		self.servers = [NSMutableArray arrayWithObjects: @"http://www.webgui.org", nil];
		[self saveServers];
	}
	[serverComboBox addItemsWithObjectValues:self.servers];
}


- (void)saveServers{
	NSString *errorString;
	NSData *serverData = [NSPropertyListSerialization dataFromPropertyList:servers format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
	[serverData writeToFile:serverFile atomically:YES];
	if (errorString != nil) {
		NSRunAlertPanel(@"WebGUI Exporter", [NSString stringWithFormat:@"Error saving server file: %@", errorString], @"OK", nil, nil);
	}
}


- (void)loadUsernames {
	if ([[NSFileManager defaultManager] fileExistsAtPath:serverToUsernameFile]) {
		NSData *usernameData = [NSData dataWithContentsOfFile:serverToUsernameFile];
		NSString *errorString;
		self.serverToUsernames = [NSPropertyListSerialization propertyListFromData:usernameData mutabilityOption:NSPropertyListMutableContainers format:nil errorDescription:&errorString];
		if (errorString != nil) {
			NSRunAlertPanel(@"WebGUI Exporter", [NSString stringWithFormat:@"Error reading username file: %@", errorString], @"OK", nil, nil);
		}
	} else {
		serverToUsernames = [[NSMutableDictionary alloc] init];
		[self saveUsernames];
	}
}


- (void)saveUsernames{
	NSString *errorString;
	NSData *usernameData = [NSPropertyListSerialization dataFromPropertyList:serverToUsernames format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
	[usernameData writeToFile:serverToUsernameFile atomically:YES];
	if (errorString != nil) {
		NSRunAlertPanel(@"WebGUI Exporter", [NSString stringWithFormat:@"Error saving username file: %@", errorString], @"OK", nil, nil);
	}
}


- (void)requestDataSuccessful {
	if (albumRequest != nil) {
		//The request was an album request
		//[albumPopUpButton addItemWithObjectValue:@"Select Album"];
		[albumPopUpButton addItemWithTitle:[NSString stringWithFormat:@"Found %i albums", [albums count]]];
		int numAlbums = albums.count;
		AlbumModel *album;
		for (int i=0; i<numAlbums; i++) {
			album = [albums objectAtIndex:i];
			[albumPopUpButton addItemWithTitle:album.title];
		}
		[albumPopUpButton selectItemAtIndex:0];
		[albumPopUpButton setEnabled:YES];
		[NSApp endSheet:waitWindow];
		[waitWindow orderOut:self];
		[waitIndicator stopAnimation:nil];
	} else if (galleryRequest != nil) {
		//The request was a gallery request
		[galleryPopUpButton addItemWithTitle:@"Select Gallery"];
		int numGalleries = galleries.count;
		GalleryModel *gallery;
		for (int i=0; i<numGalleries; i++) {
			gallery = [galleries objectAtIndex:i];
			[galleryPopUpButton addItemWithTitle:gallery.title];
		}
		[galleryPopUpButton setEnabled:YES];
		[NSApp endSheet:waitWindow];
		[waitWindow orderOut:self];
		[waitIndicator stopAnimation:nil];
	}
}


- (void)requestDataError {
	NSRunAlertPanel(@"requestDataError", @"ERROR", @"OK", nil, nil);
	[NSApp endSheet:waitWindow];
	[waitWindow orderOut:self];
	[waitIndicator stopAnimation:nil];
}


- (void)viewWillBeActivated {
}


- (void)viewWillBeDeactivated {
}


- (NSView <ExportPluginBoxProtocol> *)settingsView {
	return settingsBox;
}


- (NSString *)requiredFileType {
	return @"";
}


- (BOOL)wantsDestinationPrompt {
	return NO;
}


- (NSString *)getDestinationPath {
	return @"";
}


- (NSString *)defaultFileName {
	return @"";
}


- (NSString *)defaultDirectory {
	return @"~Pictures/";
}


- (BOOL)treatSingleSelectionDifferently {
	return NO;
}


- (BOOL)handlesMovieFiles {
	return NO;
}


- (BOOL)validateUserCreatedPath:(NSString *)path {
	return NO;
}


- (void)clickExport {
	[exportManager clickExport];
}


- (void)startExport:(NSString *)path {
	int idx = [albumPopUpButton indexOfSelectedItem];
	if ([albumPopUpButton isEnabled] && idx != 0) {
		[exportManager startExport];
	} else {
		NSRunAlertPanel(@"WebGUI Export", @"You must select an album to export the images too.", @"OK", nil, nil);
		return;
	}
}


- (void)performExport:(NSString *)path {
	UploadPhotoRequest *request = [[UploadPhotoRequest alloc] init];
	int count = [exportManager imageCount];
	BOOL succeeded = YES;
	cancelExport = NO;

	//Set initial Progress info
	[self lockProgress];
	exportProgress.indeterminateProgress = NO;
	exportProgress.totalItems = count - 1;
	[exportProgress.message autorelease];
	exportProgress.message = @"Exporting";
	[self unlockProgress];
	
	//Identify Album to upload too
	int albumIdx = [albumPopUpButton indexOfSelectedItem]-1;
	if (albumIdx >= 0) {
		uploadData.album = [albums objectAtIndex:albumIdx];
	
		for (int imgIdx=0; imgIdx<count; imgIdx++) {
			NSString *imageFileName = [exportManager imagePathAtIndex:imgIdx];
			//imageFileName = [imageFileName stringByAppendingPathComponent:[exportManager imageFileNameAtIndex:imgIdx]];
			[self lockProgress];
			exportProgress.currentItem = imgIdx;
			[exportProgress.message autorelease];
			exportProgress.message = [[NSString stringWithFormat:@"Image %d of %d to %@", imgIdx+1, count, uploadData.album.title] retain];
			[self unlockProgress];
			
			//Set image fields
			uploadData.imageFileExt = [exportManager getExtensionForImageFormat:[exportManager imageFormatAtIndex:imgIdx]];
			uploadData.imageData = [NSData dataWithContentsOfFile:imageFileName];
			[request uploadPhoto:uploadData];
			sleep(1);
		}
	} else {
		//We don't have an album so mark export as failed.
		succeeded = NO;
	}

	if (succeeded) {
		//Clean up Profress info
		[self lockProgress];
		[exportProgress.message autorelease];
		exportProgress.message = nil;
		exportProgress.shouldStop = YES;
		[self unlockProgress];
	} else {
		//Handle failure
		[self lockProgress];
		[exportProgress.message autorelease];
		exportProgress.message = [@"Unable to export" retain];
		[self cancelExport];
		exportProgress.shouldCancel = YES;
		[self unlockProgress];
	}
	
	[request release];
}


- (ExportPluginProgress *)progress {
	return &exportProgress;
}


- (void)lockProgress {
	[exportLock lock];
}


- (void)unlockProgress {
	[exportLock unlock];
}


- (void)cancelExport {
	cancelExport = YES;
}


- (NSString *)name {
	return @"WebGUI Exporter";
}


@end
