//
//  AddNewServerViewController.h
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SelectServerTableViewController;


@interface AddNewServerViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *serverTextField;
	SelectServerTableViewController *delegate;
}


@property (nonatomic, retain) UITextField *serverTextField;
@property (nonatomic, retain) SelectServerTableViewController *delegate;


- (BOOL)isOnNetwork;
- (BOOL)isWebGui:(NSString *)urlString;
- (BOOL)supportsWebServices:(NSString *)urlString;
	
@end
