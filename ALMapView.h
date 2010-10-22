//
//  ALMapView.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALDrawer.h"

@interface ALMapView : NSView {
	ALDrawer* drawer;
	ViewType currentType;
}

@property(assign) ViewType currentType;

@end
