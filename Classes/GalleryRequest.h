//
//  GalleryRequest.h
//  WebGUIPhotoAlbum
//
//  Created by Kevin Runde on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestDataDelegate.h"


@interface GalleryRequest : NSObject {
	NSString *currentText;
	NSString *currentGalleryTitle;
	NSString *currentGalleryUrl;
	NSObject <RequestDataDelegate> *delegate;
	NSMutableArray *galleries;
	NSMutableData *receivedData;
	NSXMLParser *xmlParser;
}


@property (nonatomic, retain) NSString *currentText;
@property (nonatomic, retain) NSString *currentGalleryTitle;
@property (nonatomic, retain) NSString *currentGalleryUrl;
@property (nonatomic, retain) NSObject <RequestDataDelegate> *delegate;
@property (nonatomic, retain) NSMutableArray *galleries;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSXMLParser *xmlParser;


- (void)galleriesForServer:(NSString *)serverUrl withAuth:(NSString *)authEncoding into:(NSMutableArray *)output withDelegate:(NSObject <RequestDataDelegate> *) newDelegate;


@end
