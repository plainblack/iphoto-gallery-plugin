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
	NSLog(@"Gallery URL: %@", galleryUrl);
	
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
	NSLog(@"Gallery URL: %@", galleryUrl);
	NSLog(@"URL: %@", urlString);
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	if (authEncoding != NULL) {
		NSLog(@"Using Authorization: %@", authEncoding);
		[request addValue:authEncoding forHTTPHeaderField:@"Authorization"];
	}
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection release];
	//[request release];
}


/*
 XML Parsing Delegate Methods
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"ERRROR PARSING XML");
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"XML Parsing complete");
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


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Error %@", error);
	[delegate requestDataError];
}


@end
