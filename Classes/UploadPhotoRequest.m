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
#import "UploadPhotoViewController.h"


@implementation UploadPhotoRequest


@synthesize delegate;
@synthesize receivedData;


- (void)uploadPhoto:(UploadData *)uploadData {
	//Get PNG Image Data
	NSData *imageData = UIImagePNGRepresentation(uploadData.image);
	
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
		NSLog(@"Using Authorization: %@", uploadData.authEncoding);
		[postRequest addValue:uploadData.authEncoding forHTTPHeaderField:@"Authorization"];
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
	[postBody appendData:[[NSString stringWithString:@"Uploaded from my iPhone"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"file\"; filename=\"image.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[NSData dataWithData:imageData]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"synopsis\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Uploaded from my iPhone"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSLog([[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding]);
	
	[postRequest setHTTPBody:postBody];
	
	//Send Request
	//NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
	//NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	//NSLog(returnString);
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
	[connection release];
	//[postRequest release];
}


- (void)dealloc {
	[delegate release];
	[receivedData release];
    [super dealloc];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (receivedData == nil) {
		receivedData = [[NSMutableData alloc] initWithCapacity:256];
	}
	[receivedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog([[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
	[delegate sendDataSuccessful];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection Error: %@", error);
	[delegate sendDataError];
}


@end
