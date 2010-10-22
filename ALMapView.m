//
//  ALMapView.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ALMapView.h"


@implementation ALMapView

@synthesize currentType;

-(id)initWithFrame:(NSRect)frameRect {
	if(self = [super initWithFrame:frameRect]) {
		drawer = [[ALDrawer alloc] init];
		currentType = StarMap;
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.075 target:self selector:@selector(update:) userInfo:nil repeats:YES];

	}
	return self;
}

-(void)drawRect:(NSRect)dirtyRect {
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	[drawer drawMap:currentType InContext:context viewRect:NSRectToCGRect([self bounds])];
}

-(void)setCurrentType:(ViewType)theType {
	currentType = theType;
	[self setNeedsDisplay:YES];
}

-(void)update:(id)sender {
	[self setNeedsDisplay:YES];
}

@end
