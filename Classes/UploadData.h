//
//  UploadData.h
//  WebGUIPhotoAlbum
//
//  Created by Kevin Runde on 10/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AlbumModel;
@class GalleryModel;


@interface UploadData : NSObject {
	AlbumModel *album;
	NSString *authEncoding;
	GalleryModel *gallery;
	UIImage *image;
	NSString *serverUrl;
}


@property (nonatomic, retain) AlbumModel *album;
@property (nonatomic, retain) NSString *authEncoding;
@property (nonatomic, retain) GalleryModel *gallery;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *serverUrl;


@end
