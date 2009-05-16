//
//  UploadPhotoViewController.h
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendDataDelegate.h"


@class UploadData;
@class UploadPhotoRequest;


@interface UploadPhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, SendDataDelegate> {
	UIAlertView *alertView;
	UIActivityIndicatorView *activityIndicatorView;
	UIImagePickerController *imagePicker;
	UploadData *uploadData;
	UploadPhotoRequest *uploadPhotoRequest;
}


@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UploadData *uploadData;
@property (nonatomic, retain) UploadPhotoRequest *uploadPhotoRequest;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil uploadData:(UploadData *)inUploadData;
- (IBAction)uploadFromCamera;
- (IBAction)uploadFromAlbum;
- (IBAction)viewAlbum;

@end
