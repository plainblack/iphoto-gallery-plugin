//
//  GalleryModel.h
//  WebGUIPhotoAlbum
//
//  Created by Kevin Runde on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GalleryModel : NSObject {
	NSString *title;
	NSString *url;
}


@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *url;

@end
