//
//  NewAlbumRequest.h
//  WebGUIiPhoto
//
//  Created by Kevin Runde on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class GalleryModel;


@interface NewAlbumRequest : NSObject {
}


- (NSData *) createAlbum:(NSString *)albumName forGallery:(GalleryModel *)gallery withAuthEncoding:(NSString *)authEncoding;


@end
