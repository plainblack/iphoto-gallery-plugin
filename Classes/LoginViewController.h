//
//  LoginViewController.h
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UploadData;


@interface LoginViewController : UIViewController {
	UITextField *password;
	UITextField *username;
	UploadData *uploadData;
	NSMutableDictionary *usernameByHost;
	NSString *usernameByHostFilePath;
}


@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) UploadData *uploadData;
@property (nonatomic, retain) NSMutableDictionary *usernameByHost;
@property (nonatomic, retain) NSString *usernameByHostFilePath;


- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle serverUrl:(NSString *)serverUrl;
- (IBAction)doLogin;
- (void)loadUsernames;
- (void)saveUsernames;


@end
