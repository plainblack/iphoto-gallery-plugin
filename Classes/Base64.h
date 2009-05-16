//
//  Base64.h
//  WebGUIPhotoAlbum
//
//  Created by Kevin Runde on 10/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Base64 : NSObject {

}

+ (NSString *) encodeString:(NSString *)src;
+ (NSString *) decodeString:(NSString *)src;

@end
