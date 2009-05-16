//
//  UploadData.h
//  WebGUIPhotoAlbum
//
//  Created by Kevin Runde on 10/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class AlbumModel;
@class GalleryModel;


@interface UploadData : NSObject {
	AlbumModel *album;
	NSString *authEncoding;
	GalleryModel *gallery;
	NSData *imageData;
	NSString *imageFileExt;
	NSString *serverUrl;
}


@property (nonatomic, retain) AlbumModel *album;
@property (nonatomic, retain) NSString *authEncoding;
@property (nonatomic, retain) GalleryModel *gallery;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSString *imageFileExt;
@property (nonatomic, retain) NSString *serverUrl;


@end
