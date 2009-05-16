//
//  WebGUIExportController.h
//  WebGUIiPhoto
//
//  Created by Kevin Runde on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ExportPluginProtocol.h"
#import "RequestDataDelegate.h"


@class AlbumRequest;
@class GalleryRequest;
@class UploadData;


@interface WebGUIExportController : NSObject <ExportPluginProtocol, RequestDataDelegate> {
	//Properties
	IBOutlet NSBox <ExportPluginBoxProtocol> *settingsBox;
	IBOutlet NSControl *firstView;
	IBOutlet NSComboBox *serverComboBox;
	IBOutlet NSTextField *usernameField;
	IBOutlet NSSecureTextField *passwordField;
	IBOutlet NSPopUpButton *galleryPopUpButton;
	IBOutlet NSPopUpButton *albumPopUpButton;
	IBOutlet NSWindow *waitWindow;
	IBOutlet NSProgressIndicator *waitIndicator;
	IBOutlet NSWindow *newAlbumWindow;
	IBOutlet NSTextField *newAlbumTextField;
	
	NSMutableArray *albums;
	AlbumRequest *albumRequest;
	NSMutableArray *galleries;
	GalleryRequest *galleryRequest;
	NSString *serverFile;
	NSMutableArray *servers;
	NSString *serverToUsernameFile;
	NSMutableDictionary *serverToUsernames;
	UploadData *uploadData;

	//Member Variables
	id <ExportImageProtocol> exportManager;
	ExportPluginProgress exportProgress;
	NSLock *exportLock;
	BOOL cancelExport;
}


@property (nonatomic, retain) NSBox <ExportPluginBoxProtocol> *settingsBox;
@property (nonatomic, retain) NSControl *firstView;
@property (nonatomic, retain) NSComboBox *serverComboBox;
@property (nonatomic, retain) NSTextField *usernameField;
@property (nonatomic, retain) NSSecureTextField *passwordField;
@property (nonatomic, retain) NSPopUpButton *galleryPopUpButton;
@property (nonatomic, retain) NSPopUpButton *albumPopUpButton;
@property (nonatomic, retain) NSWindow *waitWindow;
@property (nonatomic, retain) NSProgressIndicator *waitIndicator;
@property (nonatomic, retain) NSWindow *newAlbumWindow;
@property (nonatomic, retain) NSTextField *newAlbumTextField;
@property (nonatomic, retain) NSMutableArray *albums;
@property (nonatomic, retain) AlbumRequest *albumRequest;
@property (nonatomic, retain) NSMutableArray *galleries;
@property (nonatomic, retain) GalleryRequest *galleryRequest;
@property (nonatomic, retain) NSString *serverFile;
@property (nonatomic, retain) NSMutableArray *servers;
@property (nonatomic, retain) NSString *serverToUsernameFile;
@property (nonatomic, retain) NSMutableDictionary *serverToUsernames;
@property (nonatomic, retain) UploadData *uploadData;


- (void)awakeFromNib;
- (void)comboBoxSelectionDidChange:(NSNotification *)notification;
- (void)dealloc;
- (IBAction)fetchAlbums:(id)sender;
- (IBAction)fetchGalleries:(id)sender;
- (IBAction)viewServer:(id)sender;
- (IBAction)removeServer:(id)sender;
- (IBAction)viewGallery:(id)sender;
- (IBAction)viewAlbum:(id)sender;
- (IBAction)showNewAlbum:(id)sender;
- (IBAction)createNewAlbum:(id)sender;
- (IBAction)cancelNewAlbum:(id)sender;
- (void)loadServers;
- (void)saveServers;
- (void)loadUsernames;
- (void)saveUsernames;


@end
