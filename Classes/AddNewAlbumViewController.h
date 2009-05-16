//
//  AddNewAlbumViewController.h
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UploadData;
@class SelectAlbumTableViewController;


@interface AddNewAlbumViewController : UIViewController <UITextFieldDelegate> {
	UploadData *uploadData;
	SelectAlbumTableViewController *selectAlbumtTableViewController;
	IBOutlet UITextField *serverTextField;
}


@property (nonatomic, retain) UploadData *uploadData;
@property (nonatomic, retain) SelectAlbumTableViewController *selectAlbumtTableViewController;
@property (nonatomic, retain) UITextField *serverTextField;


@end
