//
//  WebGUIExportPluginBox.h
//  WebGUIiPhoto
//
//  Created by Kevin Runde on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ExportPluginProtocol.h"
#import "ExportPluginBoxProtocol.h"


@interface WebGUIExportPluginBox : NSBox <ExportPluginBoxProtocol> {
	IBOutlet id <ExportPluginProtocol> plugin;
}


- (BOOL)performKeyEquivalent:(NSEvent *)event;


@end
