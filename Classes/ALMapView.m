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
	//SETUP THE UI
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
	
	names = [NSArray arrayWithObjects:@"Reference",@"Sun",@"View",@"Time",@"Settings",@"Location",nil];
	 for (int i=0;i<[names count];i++) {
		 CALayer* testLayer = [CALayer layer];
		 [testLayer setFrame:CGRectMake(0,0, 200, 200)];
		 [testLayer addConstraint:[CAConstraint
								   constraintWithAttribute:kCAConstraintMaxX
								   relativeTo:@"superlayer"
								   attribute:kCAConstraintMaxX
								   offset:40 - (80 * i)]];
		 [testLayer addConstraint:[CAConstraint
								   constraintWithAttribute:kCAConstraintMinY
								   relativeTo:@"superlayer"
								   attribute:kCAConstraintMinY
								   offset: 62]];
		 testLayer.borderWidth = 2;
		 testLayer.borderColor = CGColorCreateGenericRGB(0.5f,0.5f,0.5f,0.7f);
		 testLayer.backgroundColor = CGColorCreateGenericRGB(0.0f,0.0f,0.0f,0.7f);
		 testLayer.cornerRadius = 10;
		 
		 [testLayer setHidden:TRUE];
		 
		ALUIButton* buttonLayer = [[ALUIButton alloc] initWithTitle:[names objectAtIndex:i] 
 																		frame:CGRectMake(-(20 + (80 * i)), 8, 80, 50)
																		layer:testLayer];
		[menuLayer addSublayer:buttonLayer];
		[rootLayer addSublayer:testLayer];
	}
	
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
	
	ALUIControl* plusLayer = [[ALUIControl alloc] initWithValue:1
														  frame:CGRectMake(0, 0, 22, 24)
															delegate:self];
	ALUIControl* minusLayer = [[ALUIControl alloc] initWithValue:-1
														  frame:CGRectMake(0, 0, 22, 24)
														delegate:self];


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
	[drawer drawMap:currentType InContext:ctx viewRect:NSRectToCGRect([self bounds])];
	[self unlockFocus];
}

- (void)mouseDown:(NSEvent *)event
{
	p = [event locationInWindow];
	
	if([[rootLayer hitTest:p] isKindOfClass:[ALUIControl class]]) {
		[[rootLayer hitTest:p] hit];
	}
	else {
		[hitLayer setFlag:FALSE];		
		if([[rootLayer hitTest:p] isKindOfClass:[ALUIButton class]]) {
			//hoe dit doen zonder warning te krijgen?
			hitLayer = [rootLayer hitTest:p];
			[hitLayer setFlag:TRUE];	
		}
		else if([[[rootLayer hitTest:p] superlayer] isKindOfClass:[ALUIButton class]]) {
			hitLayer = [[rootLayer hitTest:p] superlayer];
			[hitLayer setFlag:TRUE];	
		}
		else {
			// start tracking mouse
			if(currentType == SkyView) {
				trackingMouse = TRUE;
				[[NSCursor openHandCursor] push];
			}
		}
	}
}

- (void)mouseDragged:(NSEvent *)event
{
	if(trackingMouse == TRUE) {
	NSPoint deltap = NSMakePoint([event locationInWindow].x - p.x, [event locationInWindow].y - p.y);
	p = [event locationInWindow];
	
	Pos tmpPos = [drawer origin];
	
	//radians on half the view width
	float rad =  M_PI / [drawer zoomValue];
	//degrees on half the view width
	float deg =  90 / [drawer zoomValue];
	tmpPos.ra -= ((deltap.x / ([self frame].size.width / 2)) * rad);
	tmpPos.dec -= ((deltap.y / ([self frame].size.height / 2)) * deg);
	
	[drawer setOrigin:tmpPos];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	[[NSCursor arrowCursor] push];
	trackingMouse = FALSE;
}

- (void)scrollWheel:(NSEvent *)theEvent {
	NSLog(@"%f", [theEvent deltaY]);
	if([theEvent deltaY] == 0) return;
	if([theEvent deltaY] > 0) {
		[drawer setZoomValue:[drawer zoomValue] + 0.25];

	} else {
		[drawer setZoomValue:[drawer zoomValue] - 0.25];
	}
}


-(void)zoomHitValue:(NSNumber*)aValue {
	[drawer setZoomValue:[drawer zoomValue] + ([aValue floatValue] / 4)];
	NSLog(@"%f", [drawer zoomValue]);
}


@end
