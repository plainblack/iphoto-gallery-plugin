//
//  WebGUIPhotosAppDelegate.m
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "WebGUIPhotosAppDelegate.h"


@implementation WebGUIPhotosAppDelegate


@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
