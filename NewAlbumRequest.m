//
//  NewAlbumRequest.m
//  WebGUIiPhoto
//
//  Created by Kevin Runde on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewAlbumRequest.h"
#import "GalleryModel.h"


@implementation NewAlbumRequest


- (NSData *) createAlbum:(NSString *)albumName forGallery:(GalleryModel *)gallery withAuthEncoding:(NSString *)authEncoding {
	NSString *urlString;
	if ([gallery.url characterAtIndex:([gallery.url length]-1)] == '/') {
		urlString = [[NSString alloc] initWithFormat: @"%@", gallery.url ];
	} else {
		urlString = [[NSString alloc] initWithFormat: @"%@%@", gallery.url, @"/" ];
	}
	
	//Create the request
	NSURL *requestUrl = [NSURL URLWithString:urlString];
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:requestUrl];
	
	//setting the headers:
	[postRequest setHTTPMethod:@"POST"];
	NSString *boundary = [NSString stringWithString:@"------------0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	if (authEncoding != NULL) {
		[postRequest addValue:authEncoding forHTTPHeaderField:@"Authorization"];
	} else {
		NSRunAlertPanel(@"Gallery Request - galleriesForServer", @"No Auth Encoding being used.", @"OK", nil, nil);
	}
	
	//Create Post Body
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"func\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"addAlbumService"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"as\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"xml"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[albumName dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postRequest setHTTPBody:postBody];
	
	//Send Request
	NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
	return returnData;
}


@end
