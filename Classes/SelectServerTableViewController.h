//
//  SelectServerTableViewController.h
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectServerTableViewController : UITableViewController {
	NSString *serverFilePath;
	NSMutableArray *servers;
}


@property (nonatomic, retain) NSString *serverFilePath;
@property (nonatomic, retain) NSMutableArray *servers;


- (void)addNewServer:(NSString *)serverUrl;
- (void)loadServers;
- (void)saveServers;
- (void)showAdd;
- (void)showLogin:(NSString *) serverUrl;
- (IBAction)showInfo;


@end
