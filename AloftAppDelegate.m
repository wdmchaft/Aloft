//
//  AloftAppDelegate.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AloftAppDelegate.h"

@implementation AloftAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (IBAction)starMap:(id)sender {
	[mapView setCurrentType:StarMap];
}

- (IBAction)skyView:(id)sender {
	[mapView setCurrentType:SkyView];	
}

- (IBAction)ff:(id)sender {
	[[ALTimeManager shared] ff];
}

- (IBAction)bb:(id)sender {
	[[ALTimeManager shared] bb];
}

@end
