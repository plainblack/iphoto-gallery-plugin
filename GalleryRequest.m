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

	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	if (authEncoding != NULL) {
		[request addValue:authEncoding forHTTPHeaderField:@"Authorization"];
	}
	
	NSURLResponse *response;
	NSError *error;
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
	//Nothing to do here for now
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


@end
