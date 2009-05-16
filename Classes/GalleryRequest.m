//
//  GalleryRequest.m
//  WebGUIPhotoAlbum
//
//  Created by Kevin Runde on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GalleryRequest.h"
#import "GalleryModel.h"


@implementation GalleryRequest


@synthesize currentText;
@synthesize currentGalleryTitle;
@synthesize currentGalleryUrl;
@synthesize delegate;
@synthesize galleries;
@synthesize receivedData;
@synthesize xmlParser;


- (void)galleriesForServer:(NSString *)serverUrl withAuth:(NSString *)authEncoding into:(NSMutableArray *)output withDelegate:(NSObject <RequestDataDelegate> *) newDelegate {
	NSLog(@"Server URL: %@", serverUrl);

	//Store Link to Galleries
	self.delegate = newDelegate;
	self.galleries = output;
	
	//Request Galleries
	NSString *urlString;
	if ([serverUrl characterAtIndex:([serverUrl length]-1)] == '/') {
		urlString = [serverUrl stringByAppendingString:@"?op=findAssets;className=WebGUI::Asset::Wobject::Gallery;as=xml"];
	} else {
		urlString = [serverUrl stringByAppendingString:@"/?op=findAssets;className=WebGUI::Asset::Wobject::Gallery;as=xml"];
	}
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
	NSLog(@"ERRROR PARSING XML: %@", parseError);
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"XML Parsing complete");
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqual:@"title"]) {
		self.currentGalleryTitle = self.currentText;
	} else if ([elementName isEqual:@"url"]) {
		self.currentGalleryUrl = self.currentText;
	} else if ([elementName isEqual:@"assets"]) {
		GalleryModel *gallery = [GalleryModel alloc];
		gallery.title = self.currentGalleryTitle;
		gallery.url = self.currentGalleryUrl;
		[self.galleries addObject:	gallery];
	}
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	self.currentText = string;
}


- (void)dealloc {
	[currentText release];
	[currentGalleryTitle release];
	[currentGalleryUrl release];
	[delegate release];
	[galleries release];
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

	[galleries release];
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
