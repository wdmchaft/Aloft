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
	float h = [self elapsed];
	
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
				
				
				float azimuth = computeAzimuth(h, aStar.ra, aStar.dec, 0, 0);
				float altitude = computeAltitude(h, aStar.ra, aStar.dec, 0, 0);
				
				CGContextFillEllipseInRect(context, 
										   CGRectMake(viewRect.size.width*(azimuth / (2*M_PI)), 
													  radius*(altitude / 180), 
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
				
				float azimuth = computeAzimuth(h, aStar.ra, aStar.dec, 0, 0);
				float altitude = computeAltitude(h, aStar.ra, aStar.dec, 0, 0);
				if(altitude < 89) {
				CGContextFillEllipseInRect(context, 
										   CGRectMake(origin.x + (altitude / 90)*radius*cos(azimuth), 
													  origin.y + (altitude / 90)*radius*sin(azimuth), 
													  size, 
													  size));
				}
			}
			
			CGContextStrokeEllipseInRect(context, mapRect);
			
			break;
		default:
			break;
	}
	
}

/* MOVE TO TIME MANAGER IN DUE TIME */
-(float)elapsed {
	float elapsed;
	int dJ = [[NSDate date] timeIntervalSinceDate:[[NSDate alloc] initWithString:@"2000-01-01 00:00:00 +0000"]]; 
	
	dJ = dJ / 86400;

	float La = 99.967794687;
	float Lb = 360.9856473662860;
	float Lc = 2.907879 * pow(10, -13);
	float Ld = -5.302 * pow(10,-22);

	float sT = La + ( Lb * dJ ) + ( Lc * pow(dJ,2) ) + ( Ld * pow(dJ,3) );
	while(sT > 360) {
		sT -= 360;
	}
	elapsed = sT;
	elapsed = (M_PI / 180) * elapsed;
	elapsed += (M_PI / 180);

	return elapsed;
}

@end
