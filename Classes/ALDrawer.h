//
//  ALDrawer.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALDataManager.h"
#import "ALTimeManager.h"
#import "cmath.h"

enum ViewType {
	SkyView = 1,
	StarMap = 2
};

typedef int ViewType;

@interface ALDrawer : NSObject {
	float zoomValue;
	float width;
	Pos origin;
	Pos constellationpos[88];
}

@property (assign) float zoomValue;
@property (assign) Pos origin;

-(void)drawMap:(ViewType)mapType InContext:(CGContextRef)context viewRect:(CGRect)viewRect ;

@end
