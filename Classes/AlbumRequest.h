//
//  AlbumRequest.h
//  WebGUIPhotoAlbum
//
//  Created by Kevin Runde on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestDataDelegate.h"


@interface AlbumRequest : NSObject {
	NSMutableArray *albums;
	NSString *currentText;
	NSString *currentTitle;
	NSString *currentUrl;
	NSObject <RequestDataDelegate> *delegate;
	NSMutableData *receivedData;
	NSXMLParser *xmlParser;
}


@property (nonatomic, retain) NSMutableArray *albums;
@property (nonatomic, retain) NSString *currentText;
@property (nonatomic, retain) NSString *currentTitle;
@property (nonatomic, retain) NSString *currentUrl;
@property (nonatomic, retain) NSObject <RequestDataDelegate> *delegate;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSXMLParser *xmlParser;


- (void)albumsForGallery:(NSString *)galleryUrl withAuth:(NSString *)authEncoding into:(NSMutableArray *)output withDelegate:(NSObject <RequestDataDelegate> *) newDelegate;


@end
