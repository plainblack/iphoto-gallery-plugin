//
//  AuthCoder.m
//  WebGUIiPhoto
//
//  Created by Kevin Runde on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AuthCoder.h"

							//          1         2         3         4         5         6
							//0123456789012345678901234567890123456789012345678901234567890123
static const char *b64_tbl = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const char SIGN = -128;
static const char PAD = '=';

@implementation AuthCoder


+ (NSString *)encodeUsername:(NSString *)username password:(NSString *)password {
	if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
		return nil;
	}
	
	//Format the username and password into the correct string to be encoded
	NSString *src = [NSString stringWithFormat:@"%@:%@", username, password];
	
	//Export src to char * using ASCII encoding
	const char *srcChars = [src cStringUsingEncoding:NSASCIIStringEncoding];
	char *destChars;
	int lengthDataBits = strlen(srcChars) * 8;
	int fewerThan24bits = lengthDataBits % 24;
	int numberTriplets = lengthDataBits / 24;
	int encodedDataLength;
	int currentChunk;
	
	if (fewerThan24bits != 0) {
		//data not divisible by 24 bit
		encodedDataLength = (numberTriplets + 1) * 4;
	} else {
		// 16 or 8 bit
		encodedDataLength = numberTriplets * 4;
	}
	
	//Create new char * based on length estimating
	NSLog(@"src: %@, srcChars: %s", src, srcChars);
	//destChars = new char[encodedDataLength];
	destChars = (char *)malloc(encodedDataLength+1);
	destChars[encodedDataLength] = '\0';
	
	//Now copy from src to dest in groups of 3
	int destIndex = 0;
	int srcIndex = 0;
	for(currentChunk=0; currentChunk < numberTriplets; currentChunk++) {
		NSLog(@"Processing Chunk %d", currentChunk);
		
		//ENCODE THIS GROUP
		char char1 = srcChars[srcIndex];
		char char2 = srcChars[srcIndex+1];
		char char3 = srcChars[srcIndex+2];
		char k = char1 & 0x03;
		char l = char2 & 0x0f;
		char val1 = (char1 & SIGN) == 0 ? char1 >> 2 : (char1 >> 2) ^ 0Xc0;
		char val2 = (char2 & SIGN) == 0 ? char2 >> 4 : (char2 >> 4) ^ 0Xf0;
		char val3 = (char3 & SIGN) == 0 ? char3 >> 6 : (char3 >> 6) ^ 0Xfc;
		NSLog(@"Encoding %c,%c,%c", char1, char2, char3);
        // upper 6 bits of char1
		destChars[destIndex] = b64_tbl[val1];
		
        // lower 2 bits of char1 | upper 4 bits of char2
        destChars[destIndex+1] = b64_tbl[val2 | (k << 4)];
		
        // lower 4 bits of char2 | upper 2 bits of char3
        destChars[destIndex+2] = b64_tbl[(l <<2) | val3];
		
        // lower 6 bits of char3
        destChars[destIndex+3] = b64_tbl[char3 & 0x3f];
		
		//Update Indexes
		destIndex += 4;
		srcIndex += 3;
	}
	
	if (fewerThan24bits == 16) {
		NSLog(@"Processing last 2 chars");
		
		//ENCODE THIS GROUP
		char char1 = srcChars[srcIndex];
		char char2 = srcChars[srcIndex+1];
		char k = char1 & 0x03;
		char l = char2 & 0x0f;
		char val1 = (char1 & SIGN) == 0 ? char1 >> 2 : (char1 >> 2) ^ 0Xc0;
		char val2 = (char2 & SIGN) == 0 ? char2 >> 4 : (char2 >> 4) ^ 0Xf0;
		NSLog(@"Encoding %c,%c", char1, char2);
        // upper 6 bits of char1
		destChars[destIndex] = b64_tbl[val1];
		
        // lower 2 bits of char1 | upper 4 bits of char2
        destChars[destIndex+1] = b64_tbl[val2 | (k << 4)];
		
        // lower 4 bits of char2 | upper 2 bits of char3
        destChars[destIndex+2] = b64_tbl[(l <<2)];
		
        // PAD since there is no data for this
        destChars[destIndex+3] = PAD;
		
		//Update Indexes
		destIndex += 4;
		srcIndex += 3;
	} else if (fewerThan24bits == 8) {
		NSLog(@"Processing last char");
		
		//ENCODE THIS GROUP
		char char1 = srcChars[srcIndex];
		char k = char1 & 0x03;
		char val1 = (char1 & SIGN) == 0 ? char1 >> 2 : (char1 >> 2) ^ 0Xc0;
		NSLog(@"Encoding %c", char1);
        //upper 6 bits of char1
		destChars[destIndex] = b64_tbl[val1];
		
        // lower 2 bits of char1 | upper 4 bits of char2
        destChars[destIndex+1] = b64_tbl[(k << 4)];
		
        // PAD since there is no data for this
        destChars[destIndex+2] = PAD;
		
        // PAD since there is no data for this
        destChars[destIndex+3] = PAD;
		
		//Update Indexes
		destIndex += 4;
		srcIndex += 3;
	}
	
	NSLog(@"Creating dest encodeLength: %i, destIndex: %d, of: %s", encodedDataLength, destIndex, destChars);
	NSString *dest = [[NSString alloc] initWithCString:destChars encoding:NSASCIIStringEncoding];
	free(destChars);
	
	return dest;
}


@end
