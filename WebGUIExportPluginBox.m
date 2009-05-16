//
//  WebGUIExportPluginBox.m
//  WebGUIiPhoto
//
//  Created by Kevin Runde on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WebGUIExportPluginBox.h"


@implementation WebGUIExportPluginBox


- (BOOL)performKeyEquivalent:(NSEvent *)event {
	NSString *keyString = [event charactersIgnoringModifiers];
	unichar keyChar = [keyString characterAtIndex:0];
	
	switch (keyChar) {
		case NSFormFeedCharacter:
		case NSNewlineCharacter:
		case NSCarriageReturnCharacter:
		case NSEnterCharacter:
			/*
			 This makes any return start the export which is not what we want. Cause we have several form fields that should be entered
			[plugin clickExport];
			*/
			return YES;
			break;
		default:
			break;
	}
	return [super performKeyEquivalent:event];
}


@end
