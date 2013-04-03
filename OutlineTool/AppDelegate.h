//
//  AppDelegate.h
//  OutlineTool
//
//  Created by Anand Baumunk on 28.03.13.
//  Copyright Anand Baumunk 2013. All rights reserved.
//

#import "cocos2d.h"

@interface OutlineToolAppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow	*window_;
	CCGLView	*glView_;
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet CCGLView	*glView;

- (IBAction)toggleFullScreen:(id)sender;

@end
