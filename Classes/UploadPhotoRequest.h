//
//  UploadPhotoRequest.h
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendDataDelegate.h"


@class UploadData;


@interface UploadPhotoRequest : NSObject {
	NSObject <SendDataDelegate> *delegate;
	NSMutableData *receivedData;
}


@property (nonatomic, retain) NSObject <SendDataDelegate> *delegate;
@property (nonatomic, retain) NSMutableData *receivedData;


- (void)uploadPhoto:(UploadData *)uploadData;


@end
