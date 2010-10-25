//
//  ALMapView.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ALMapView.h"
#import <Quartz/Quartz.h>

@implementation ALMapView

@synthesize currentType;

-(void)awakeFromNib {
	//[self enterFullScreenMode:[self.window screen] withOptions:NULL];
	
	drawer = [[ALDrawer alloc] init];
	currentType = SkyView;
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.075 target:self selector:@selector(update:) userInfo:nil repeats:YES];
	
	[self setupLayers];

}

-(void)setCurrentType:(ViewType)theType {
	currentType = theType;
	[rootLayer layoutIfNeeded];
	[rootLayer setNeedsDisplay];
}

-(void)update:(id)sender {
	[rootLayer layoutIfNeeded];
	[rootLayer setNeedsDisplay];
}

-(void)setupLayers {
	rootLayer = [CALayer layer];
	[self setWantsLayer:YES];
	[rootLayer addSublayer:menuLayer];
	[rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
	
	[rootLayer setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
	
	menuLayer = [CALayer layer] ;
	menuLayer.frame= CGRectMake(0, 0, [rootLayer frame].size.width, 60);
	menuLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	[menuLayer setContents:[NSImage imageNamed:@"nav.png"]];
	[rootLayer addSublayer:menuLayer];
	[self setLayer:rootLayer];
	
	[menuLayer setAutoresizingMask:kCALayerWidthSizable];

	
    //Create whiteColor it's used to draw the text and also in the selectionLayer
    CGColorRef whiteColor=CGColorCreateGenericRGB(1.0f,1.0f,1.0f,1.0f);
	
	
	names = [NSArray arrayWithObjects:@"Reference",@"Sun",@"View",@"Time",@"Settings",@"Location",nil];
	 for (int i=0;i<[names count];i++) {
		 CALayer *buttonLayer = [CALayer layer];
		 buttonLayer.frame = CGRectMake(0, 0, 80, 50);
		 buttonLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
		 [buttonLayer addConstraint:[CAConstraint
									   constraintWithAttribute:kCAConstraintMaxX
									   relativeTo:@"superlayer"
									   attribute:kCAConstraintMaxX
									 offset: -(20 + (80 * i))]];
		 
		 [buttonLayer addConstraint:[CAConstraint
									 constraintWithAttribute:kCAConstraintMinY
									 relativeTo:@"superlayer"
									 attribute:kCAConstraintMinY
									 offset: 8]];
		 
		 CATextLayer *menuItemLayer = [CATextLayer layer];
		 menuItemLayer.string = [names objectAtIndex:i];
		 menuItemLayer.font=@"Helvetica-Bold";
		 menuItemLayer.fontSize=12;
		 menuItemLayer.foregroundColor=whiteColor;
		 [menuItemLayer addConstraint:[CAConstraint
									   constraintWithAttribute:kCAConstraintMidX
									   relativeTo:@"superlayer"
									   attribute:kCAConstraintMidX]];
		 [menuItemLayer addConstraint:[CAConstraint
									   constraintWithAttribute:kCAConstraintMinY
									   relativeTo:@"superlayer"
									   attribute:kCAConstraintMinY
									   offset: 0]];	
		 
		 [buttonLayer addSublayer:menuItemLayer];
		 
		 CALayer *iconLayer = [CALayer layer];
		 iconLayer.contents = [NSImage imageNamed:[NSString stringWithFormat:@"icon_%@_off.png",[[names objectAtIndex:i] lowercaseString]]];
		 [iconLayer addConstraint:[CAConstraint
								   constraintWithAttribute:kCAConstraintMidX
								   relativeTo:@"superlayer"
								   attribute:kCAConstraintMidX]];
		 [iconLayer addConstraint:[CAConstraint
									   constraintWithAttribute:kCAConstraintMinY
									   relativeTo:@"superlayer"
									   attribute:kCAConstraintMinY
									   offset: 12]];	
		 iconLayer.frame = CGRectMake(0, 0, 35, 35);
		 [buttonLayer addSublayer:iconLayer];
		
		 NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position",
											[NSNull null], @"frame",
											[NSNull null], @"bounds",
											nil];
		 buttonLayer.actions = newActions;
		 [newActions release];
		 
		// [buttonLayer setAutoresizingMask:kCALayerMinXMargin];
		 
		 [menuLayer addSublayer:buttonLayer];
	 }
	
	/* NSInteger i;
    for (i=0;i<[names count];i++) {
        menuItemLayer.string=[self.names objectAtIndex:i];
        menuItemLayer.font=@"Lucida-Grande";
        menuItemLayer.fontSize=12;
        menuItemLayer.foregroundColor=whiteColor;
        [menuLayer addSublayer:menuItemLayer];
    } // end of for loop */
	
	//add zoom controls
	int height = 150;
	CALayer* zoomLayer = [CALayer layer];
	zoomLayer.frame = CGRectMake(0, 0, 50, height);
	zoomLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	[zoomLayer addConstraint:[CAConstraint
							  constraintWithAttribute:kCAConstraintMinX
							  relativeTo:@"superlayer"
							  attribute:kCAConstraintMinX
							  offset:20]];
	[zoomLayer addConstraint:[CAConstraint
							  constraintWithAttribute:kCAConstraintMaxY
							  relativeTo:@"superlayer"
							  attribute:kCAConstraintMaxY
							  offset: -50]];
	
	
	CALayer* plusLayer = [CALayer layer];
	[plusLayer setContents:[NSImage imageNamed:@"plus.png"]];
	plusLayer.frame = CGRectMake(0, 0, 22, 24);
	[plusLayer addConstraint:[CAConstraint
							  constraintWithAttribute:kCAConstraintMidX
							  relativeTo:@"superlayer"
							  attribute:kCAConstraintMidX]];
	[plusLayer addConstraint:[CAConstraint
							  constraintWithAttribute:kCAConstraintMaxY
							  relativeTo:@"superlayer"
							  attribute:kCAConstraintMaxY]];
	
	CALayer* minusLayer = [CALayer layer];
	[minusLayer setContents:[NSImage imageNamed:@"minus.png"]];
	minusLayer.frame = CGRectMake(0, 0, 22, 24);
	[minusLayer addConstraint:[CAConstraint
							  constraintWithAttribute:kCAConstraintMidX
							  relativeTo:@"superlayer"
							  attribute:kCAConstraintMidX]];
	[minusLayer addConstraint:[CAConstraint
							  constraintWithAttribute:kCAConstraintMinY
							  relativeTo:@"superlayer"
							  attribute:kCAConstraintMinY]];
	
	CALayer* lineLayer = [CALayer layer];
	[lineLayer setContents:[NSImage imageNamed:@"line.png"]];
	lineLayer.frame = CGRectMake(0, 0, 5, height - 50);
	[lineLayer addConstraint:[CAConstraint
							  constraintWithAttribute:kCAConstraintMidX
							  relativeTo:@"superlayer"
							  attribute:kCAConstraintMidX]];
	[lineLayer addConstraint:[CAConstraint
							  constraintWithAttribute:kCAConstraintMidY
							  relativeTo:@"superlayer"
							  attribute:kCAConstraintMidY]];
	
	CALayer* controlLayer = [CALayer layer];
	[controlLayer setContents:[NSImage imageNamed:@"slider.png"]];
	controlLayer.frame = CGRectMake(0, 0, 22, 6);
	[controlLayer addConstraint:[CAConstraint
							  constraintWithAttribute:kCAConstraintMidX
							  relativeTo:@"superlayer"
							  attribute:kCAConstraintMidX]];
	[controlLayer addConstraint:[CAConstraint
							  constraintWithAttribute:kCAConstraintMidY
							  relativeTo:@"superlayer"
							  attribute:kCAConstraintMidY]];
	
	[zoomLayer addSublayer:lineLayer];
	[zoomLayer addSublayer:plusLayer];
	[zoomLayer addSublayer:minusLayer];
	[zoomLayer addSublayer:controlLayer];
	
	[zoomLayer setAutoresizingMask:(kCALayerMaxXMargin | kCALayerMinYMargin)];

	
	[rootLayer addSublayer:zoomLayer];
	
	[rootLayer setNeedsDisplayOnBoundsChange:YES];
	[rootLayer setDelegate:self];
	[rootLayer setNeedsDisplay];
}

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	[self lockFocus];	
	[drawer drawMap:currentType InContext:ctx  viewRect:NSRectToCGRect([self bounds])];
	[self unlockFocus];
}

@end
