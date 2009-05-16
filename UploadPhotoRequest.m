//
//  UploadPhotoRequest.m
//  WebGUIPhotos
//
//  Created by Kevin Runde on 11/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UploadPhotoRequest.h"
#import "AlbumModel.h"
#import "UploadData.h"


@implementation UploadPhotoRequest


- (NSData *)uploadPhoto:(UploadData *)uploadData {
	//Create the URL
	NSString *urlString;
	if ([uploadData.album.url characterAtIndex:([uploadData.album.url length]-1)] == '/') {
		urlString = [[NSString alloc] initWithFormat: @"%@", uploadData.album.url ];
	} else {
		urlString = [[NSString alloc] initWithFormat: @"%@%@", uploadData.album.url, @"/" ];
	}
	
	//Create the request
	NSURL *requestUrl = [NSURL URLWithString:urlString];
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:requestUrl];
	
	//setting the headers:
	[postRequest setHTTPMethod:@"POST"];
	if (uploadData.authEncoding != NULL) {
		[postRequest addValue:uploadData.authEncoding forHTTPHeaderField:@"Authorization"];
	} else {
		NSRunAlertPanel(@"Gallery Request - galleriesForServer", @"No Auth Encoding being used.", @"OK", nil, nil);
	}
	NSString *boundary = [NSString stringWithString:@"------------0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	//Create Post Body
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"func\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"addFileService"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"as\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"xml"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Uploaded from iPhoto"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:uploadData.imageData];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"synopsis\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Uploaded from iPhoto"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSLog([[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding]);
	
	[postRequest setHTTPBody:postBody];
	
	//Send Request
	NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];

	return returnData;
}


- (void)dealloc {
    [super dealloc];
}


@end
