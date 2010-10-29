//
//  ALMapView.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALDrawer.h"
#import "ALUIButton.h"
#import "ALUIControl.h"

@interface ALMapView : NSView {
	ALDrawer* drawer;
	ViewType currentType;
	
	//MOUSE SUPPORT
	ALUIButton* hitLayer;
	BOOL trackingMouse;
	BOOL draggingSlider;

	NSTimer* updateTimer;
	
	NSArray* names;
	
	CALayer* rootLayer;
	CALayer* menuLayer;
	CALayer* controlLayer;
	
	float zoomValue;
	
	NSPoint p;
}

@property(assign) ViewType currentType;

-(void)setupLayers;
-(void)zoomHitValue:(NSNumber*)aValue;
-(void)setZoomSlider;
-(void)toggleFullScreen;

@end
