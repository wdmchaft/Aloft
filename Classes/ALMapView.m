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
	
	menuLayer = [CALayer layer] ;
	menuLayer.frame= CGRectMake(0, 0, [self frame].size.width, 60);
	menuLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	[menuLayer setContents:[NSImage imageNamed:@"nav.png"]];
	[rootLayer addSublayer:menuLayer];
	[self setLayer:rootLayer];
	
    //Create whiteColor it's used to draw the text and also in the selectionLayer
    CGColorRef whiteColor=CGColorCreateGenericRGB(1.0f,1.0f,1.0f,1.0f);
	
	names = [NSArray arrayWithObjects:@"Reference",@"Sun",@"View",@"Time",@"Settings",@"Location",nil];
	 for (int i=0;i<[names count];i++) {
		 CALayer *buttonLayer = [CALayer layer];
		 buttonLayer.frame = CGRectMake(menuLayer.frame.size.width - (100 + (80 * i)), 10, 80, 50);
		 buttonLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
		 
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
