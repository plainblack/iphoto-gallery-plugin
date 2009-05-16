//
//  AuthCoder.h
//  WebGUIiPhoto
//
//  Created by Kevin Runde on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AuthCoder : NSObject {

}


+ (NSString *)encodeUsername:(NSString *)username password:(NSString *)password;

@end
