//
//  AlbumRequest.m
//  WebGUIPhotoAlbum
//
//  Created by Kevin Runde on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AlbumRequest.h"
#import "AlbumModel.h"


@implementation AlbumRequest


@synthesize albums;
@synthesize currentText;
@synthesize currentTitle;
@synthesize currentUrl;
@synthesize delegate;
@synthesize receivedData;
@synthesize xmlParser;


- (void)albumsForGallery:(NSString *)galleryUrl withAuth:(NSString *)authEncoding into:(NSMutableArray *)output withDelegate:(NSObject <RequestDataDelegate> *) newDelegate {
	
	//Store Link to Galleries
	self.delegate = newDelegate;
	self.albums = output;
	
	//Request photo albums
	NSString *urlString;
	if ([galleryUrl characterAtIndex:([galleryUrl length]-1)] == '/') {
		urlString = [galleryUrl stringByAppendingString:@"?func=listAlbumsService;as=xml"];
	} else {
		urlString = [galleryUrl stringByAppendingString:@"/?func=listAlbumsService;as=xml"];
	}
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	if (authEncoding != NULL) {
		[request addValue:authEncoding forHTTPHeaderField:@"Authorization"];
	} else {
		NSRunAlertPanel(@"Gallery Request - albumsForServer", @"No Auth Encoding being used.", @"OK", nil, nil);
	}
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (urlData == nil) {
		NSAlert *alert = [NSAlert alertWithError:error];
		[alert runModal];
	}
	[self connection:nil didReceiveData:urlData];
	[self connectionDidFinishLoading:nil];
}


/*
 XML Parsing Delegate Methods
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSAlert *alert = [NSAlert alertWithError:parseError];
	[alert runModal];
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//Nothing to do here
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqual:@"title"]) {
		self.currentTitle = self.currentText;
	} else if ([elementName isEqual:@"url"]) {
		self.currentUrl = self.currentText;
	} else if ([elementName isEqual:@"albums"]) {
		AlbumModel *album = [AlbumModel alloc];
		album.title = self.currentTitle;
		album.url = self.currentUrl;
		[self.albums addObject:	album];
	}
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	self.currentText = string;
}


- (void)dealloc {
	[albums release];
	[currentText release];
	[currentTitle release];
	[currentUrl release];
	[delegate release];
	[receivedData release];
	[xmlParser release];
    [super dealloc];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (receivedData == nil) {
		receivedData = [[NSMutableData alloc] initWithCapacity:256];
	}
	[receivedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
	[self.xmlParser setDelegate:self];
	BOOL result = [self.xmlParser parse];
	
	[albums release];
	if (result) {
		[delegate requestDataSuccessful];
	} else {
		[delegate requestDataError];
	}
}


@end
