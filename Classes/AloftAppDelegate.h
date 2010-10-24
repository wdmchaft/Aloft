//
//  AloftAppDelegate.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALMapView.h"
#import "ALDataManager.h"
#import "ALTimeManager.h"

@interface AloftAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet NSButton* starMapButton;
	IBOutlet NSButton* skyViewButton;
	IBOutlet NSButton* ffButton;
	IBOutlet NSButton* bbButton;

	IBOutlet ALMapView* mapView;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)starMap:(id)sender;
- (IBAction)skyView:(id)sender;
- (IBAction)ff:(id)sender;
- (IBAction)bb:(id)sender;

@end
