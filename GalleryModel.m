//
//  GalleryModel.m
//  WebGUIPhotoAlbum
//
//  Created by Kevin Runde on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GalleryModel.h"


@implementation GalleryModel


@synthesize title;
@synthesize url;


- (void)dealloc {
	[title release];
	[url release];
    [super dealloc];
}


@end
