//
//  ALUIControl.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 26-10-10.
//  Copyright 2010 Web6.nl Diensten. All rights reserved.
//

#import "ALUIControl.h"
#import <Quartz/Quartz.h>


@implementation ALUIControl

-(id)initWithValue:(int)theValue frame:(CGRect)aFrame delegate:(id)aDelegate {
	
	if(self = [super init]) {
		value = theValue;
		delegate = aDelegate;
		
		if(value == 1) {
			[self setContents:[NSImage imageNamed:@"plus.png"]];
			self.frame = aFrame;
			[self addConstraint:[CAConstraint
									  constraintWithAttribute:kCAConstraintMidX
									  relativeTo:@"superlayer"
									  attribute:kCAConstraintMidX]];
			[self addConstraint:[CAConstraint
									  constraintWithAttribute:kCAConstraintMaxY
									  relativeTo:@"superlayer"
									  attribute:kCAConstraintMaxY]];		
		}
		else if(value == -1) {
			[self setContents:[NSImage imageNamed:@"minus.png"]];
			self.frame = aFrame;
			[self addConstraint:[CAConstraint
									  constraintWithAttribute:kCAConstraintMidX
									  relativeTo:@"superlayer"
									  attribute:kCAConstraintMidX]];
			[self addConstraint:[CAConstraint
									  constraintWithAttribute:kCAConstraintMinY
									  relativeTo:@"superlayer"
									  attribute:kCAConstraintMinY]];		
		}
	}
	return self;
}

-(void)hit {
	if ((delegate != nil) && ([delegate respondsToSelector:@selector(zoomHitValue:)])) {
		[delegate performSelector:@selector(zoomHitValue:) withObject:[NSNumber numberWithInt:value]];
	}
}

@end
