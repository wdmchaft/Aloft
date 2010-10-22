//
//  ALDrawer.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ALDrawer.h"


@implementation ALDrawer

-(void)drawMap:(ViewType)viewType InContext:(CGContextRef)context viewRect:(CGRect)viewRect {
	NSMutableArray* stars = [[ALDataManager shared] stars];
	
	CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.05, 0.05, 0.05, 1.0));
	CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(0.1, 0.1, 0.1, 1.0));
	CGContextSetLineWidth(context, 1.0);
	CGContextFillRect(context, viewRect);		
	float radius;
	int size;
	
	switch (viewType) {
		case SkyView:
			radius = viewRect.size.height;
			//geometric variables						
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.9));
			for(int i = 0; i < [stars count]; ++i) {
				NSValue* boxedStar = [stars objectAtIndex:i];
				struct Star aStar;
				if (strcmp([boxedStar objCType], @encode(struct Star)) == 0) {
					[boxedStar getValue:&aStar];
				}				
				
				if(aStar.mag < 1.0) { size = 4; }
				else if(aStar.mag < 2.0) { size = 3; }
				else if(aStar.mag < 3.0) { size = 2; }
				else { size = 1; }
				
				CGContextFillEllipseInRect(context, 
										   CGRectMake(viewRect.size.width*aStar.ra / (2*M_PI), 
													  radius*(aStar.dec / 180), 
													  size, 
													  size));
			}
				
			break;
		
		case StarMap:
			//geometric variables
			radius = (viewRect.size.height - 40) / 2;
			CGRect mapRect = {	
				(viewRect.size.width / 2) - radius, 
				(viewRect.size.height / 2) - radius,
				radius * 2, 
				radius * 2};
			
			CGPoint origin = CGPointMake(viewRect.size.width / 2, viewRect.size.height / 2);
			
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.05));
			CGContextFillEllipseInRect(context, mapRect);
			CGContextStrokeEllipseInRect(context, mapRect);
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.9));

			for(int i = 0; i < [stars count]; ++i) {
				NSValue* boxedStar = [stars objectAtIndex:i];
				struct Star aStar;
				if (strcmp([boxedStar objCType], @encode(struct Star)) == 0) {
					[boxedStar getValue:&aStar]; }				
				
				if(aStar.mag < 1.0) { size = 4; }
				else if(aStar.mag < 2.0) { size = 3; }
				else if(aStar.mag < 3.0) { size = 2; }
				else { size = 1; }
				
				CGContextFillEllipseInRect(context, 
										   CGRectMake(origin.x + (aStar.dec / 180)*radius*cos(aStar.ra), 
													  origin.y + (aStar.dec / 180)*radius*sin(aStar.ra), 
													  size, 
													  size));
			}
			
			break;
		default:
			break;
	}
	
}


@end
