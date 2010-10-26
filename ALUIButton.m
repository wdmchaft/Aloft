//
//  ALUIButton.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 26-10-10.
//  Copyright 2010 Web6.nl Diensten. All rights reserved.
//

#import "ALUIButton.h"
#import <Quartz/Quartz.h>

@implementation ALUIButton

-(id)initWithTitle:(NSString*)theTitle frame:(CGRect)theFrame layer:(CALayer*)theLayer {
	if(self = [super init]) {
		title = theTitle;
		on = FALSE;
		view = theLayer;
		
		CGColorRef whiteColor=CGColorCreateGenericRGB(1.0f,1.0f,1.0f,1.0f);
		
		self.frame = CGRectMake(0, 0, theFrame.size.width, theFrame.size.height);
		self.layoutManager = [CAConstraintLayoutManager layoutManager];
		
		[self addConstraint:[CAConstraint
									constraintWithAttribute:kCAConstraintMaxX
									relativeTo:@"superlayer"
									attribute:kCAConstraintMaxX
									offset: theFrame.origin.x]];
		
		[self addConstraint:[CAConstraint
									constraintWithAttribute:kCAConstraintMinY
									relativeTo:@"superlayer"
									attribute:kCAConstraintMinY
									offset: theFrame.origin.y]]; 
		
		textLayer = [CATextLayer layer];
		textLayer.string = title;
		textLayer.font=@"Helvetica-Bold";
		textLayer.fontSize=12;
		textLayer.foregroundColor=whiteColor;
		[textLayer addConstraint:[CAConstraint
									  constraintWithAttribute:kCAConstraintMidX
									  relativeTo:@"superlayer"
									  attribute:kCAConstraintMidX]];
		[textLayer addConstraint:[CAConstraint
									  constraintWithAttribute:kCAConstraintMinY
									  relativeTo:@"superlayer"
									  attribute:kCAConstraintMinY
									  offset: 0]];	
		
		[self addSublayer:textLayer];
		
		iconLayer = [CALayer layer];
		iconLayer.contents = [NSImage imageNamed:[NSString stringWithFormat:@"icon_%@_off.png",[title lowercaseString]]]; //
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
		[self addSublayer:iconLayer];
		
		NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position",
										   [NSNull null], @"frame",
										   [NSNull null], @"bounds",
										   nil];
		self.actions = newActions;
		[newActions release]; 
	}
	return self;
}

-(void)setFlag:(BOOL)turnOn {
	on = turnOn;
	if(on == FALSE) {
	//set off	
		iconLayer.contents = [NSImage imageNamed:[NSString stringWithFormat:@"icon_%@_off.png",[title lowercaseString]]];
		view.hidden = YES;
	}
	else if(on == TRUE) {
	//set on
		iconLayer.contents = [NSImage imageNamed:[NSString stringWithFormat:@"icon_%@_on.png",[title lowercaseString]]];
		view.hidden = NO;
	}
	
	//do view stuff
}

@end
