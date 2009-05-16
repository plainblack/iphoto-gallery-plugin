//
//  SelectAlbumTableViewController.h
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"RequestDataDelegate.h"


@class UploadData;


@interface SelectAlbumTableViewController : UITableViewController <RequestDataDelegate> {
	NSMutableArray * albums;
	UIAlertView *alertView;
	UIActivityIndicatorView *activityIndicatorView;
	UploadData *uploadData;
}

@property (nonatomic, retain) NSMutableArray *albums;
@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) UploadData *uploadData;

- (void)refreshData;

@end
