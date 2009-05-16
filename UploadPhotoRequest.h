//
//  UploadPhotoRequest.h
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class UploadData;


@interface UploadPhotoRequest : NSObject {
}


- (NSData *)uploadPhoto:(UploadData *)uploadData;


@end
