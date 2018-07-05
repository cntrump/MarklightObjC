//
//  AppDelegate.m
//  MarklightSample macOS
//
//  Created by vvveiii on 2018/7/5.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    self.window.contentViewController = [[ViewController alloc] init];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
