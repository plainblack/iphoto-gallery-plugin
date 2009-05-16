//
//  SelectGalleryTableViewController.h
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestDataDelegate.h"


@class GalleryRequest;
@class UploadData;


@interface SelectGalleryTableViewController : UITableViewController <RequestDataDelegate> {
	UIAlertView *alertView;
	UIActivityIndicatorView *activityIndicatorView;
	NSMutableArray *galleries;
	UploadData *uploadData;
}


@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) NSMutableArray *galleries;
@property (nonatomic, retain) UploadData *uploadData;


@end
