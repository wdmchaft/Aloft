//
//  ALDrawer.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALDataManager.h"
#import "cmath.h"

enum ViewType {
	SkyView = 1,
	StarMap = 2
};

typedef int ViewType;

@interface ALDrawer : NSObject {
	//move to time manager
	NSTimer* timeTest;
	NSDate* simulatedDate;
	NSDate* actualDate;
	int speed;
}

-(void)drawMap:(ViewType)mapType InContext:(CGContextRef)context viewRect:(CGRect)viewRect ;
-(float)elapsed;

@end
