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
	NSMutableArray* positions = [[ALDataManager shared] positions];
	
	CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.05, 0.05, 0.05, 1.0));
	CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(0.1, 0.1, 0.1, 1.0));
	CGContextSetLineWidth(context, 1.0);
	CGContextFillRect(context, viewRect);		
	float radius;
	int size;
	float h = [[ALTimeManager shared] elapsed];
	
	switch (viewType) {
		case SkyView:
			radius = viewRect.size.height;
			//geometric variables						
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 0.0, 0.0, 0.9));
			
			//draw constellations
			CGContextBeginPath(context);
			float azimuth_old = M_PI;
			for(int i = 0; i < [positions count]; ++i) {
				NSValue* boxedPos = [positions objectAtIndex:i];
				struct Pos aPos;

				if (strcmp([boxedPos objCType], @encode(struct Pos)) == 0) {
					[boxedPos getValue:&aPos]; 
				
					float azimuth = computeAzimuth(h, aPos.ra, aPos.dec, 52, 5);
					float altitude = computeAltitude(h, aPos.ra, aPos.dec, 52, 5);

					if((i % 2) == 0) {
						CGContextMoveToPoint(context, viewRect.size.width*(azimuth / (2*M_PI)), radius*(altitude / 180));	
						azimuth_old = azimuth;
					}
					 else {
						 if(ABS(azimuth_old - azimuth) > 3) {
							 if(azimuth_old < M_PI) {
								 azimuth -= 2*M_PI;
							 }
							 else {
								 azimuth += 2*M_PI;
							 }
						 }
						CGContextAddLineToPoint(context, viewRect.size.width*(azimuth / (2*M_PI)), radius*(altitude / 180));	
					}
				}

			}
			
			CGContextClosePath(context);
						
			CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(0.4, 0.65, 1.0, 0.15));
			CGContextSetLineWidth(context, 1.0);
			CGContextStrokePath(context);
			
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
				
				float azimuth = computeAzimuth(h, aStar.pos.ra, aStar.pos.dec, 52, 5);
				float altitude = computeAltitude(h, aStar.pos.ra, aStar.pos.dec, 52, 5);
				
				CGContextFillEllipseInRect(context, 
										   CGRectMake(viewRect.size.width*(azimuth / (2*M_PI)), 
													  radius*(altitude / 180), 
													  size, 
													  size));
			}
				
			break;
		
		case StarMap:			
			//geometric variables
			radius = (viewRect.size.height - 50) / 2;
			CGRect mapRect = {	
				(viewRect.size.width / 2) - radius, 
				(viewRect.size.height / 2) - radius,
				radius * 2, 
				radius * 2};
			
			CGPoint origin = CGPointMake(viewRect.size.width / 2, viewRect.size.height / 2);
			
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.05));
			CGContextFillEllipseInRect(context, mapRect);
			
			//draw constellations
			CGContextBeginPath(context);
			azimuth_old = M_PI;
			BOOL skipline = FALSE;
			for(int i = 0; i < [positions count]; ++i) {
				NSValue* boxedPos = [positions objectAtIndex:i];
				struct Pos aPos;
				
				if (strcmp([boxedPos objCType], @encode(struct Pos)) == 0) {
					[boxedPos getValue:&aPos]; 
					
					float azimuth = computeAzimuth(h, aPos.ra, aPos.dec, 52, 5);
					float altitude = computeAltitude(h, aPos.ra, aPos.dec, 52, 5);
					
					if((i % 2) == 0) {
						if(altitude < 90) {
							CGContextMoveToPoint(context, origin.x + (altitude / 90)*radius*cos(azimuth), origin.y + (altitude / 90)*radius*sin(azimuth));	
						}
						else {
							skipline = TRUE;	
						}
					}
					else {
						if(altitude < 90 && !skipline) {
						CGContextAddLineToPoint(context, origin.x + (altitude / 90)*radius*cos(azimuth), origin.y + (altitude / 90)*radius*sin(azimuth));	
						}
						skipline = FALSE;
					}
				}
			}
			
			CGContextClosePath(context);
			
			CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(0.4, 0.65, 1.0, 0.15));
			CGContextSetLineWidth(context, 1.0);
			CGContextStrokePath(context);
			
			//drawing stars
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
				
				float azimuth = computeAzimuth(h, aStar.pos.ra, aStar.pos.dec, 52, 5);
				float altitude = computeAltitude(h, aStar.pos.ra, aStar.pos.dec, 52, 5);
				if(altitude < 89) {
					CGContextFillEllipseInRect(context, 
										   CGRectMake(origin.x + (altitude / 90)*radius*cos(azimuth), 
													  origin.y + (altitude / 90)*radius*sin(azimuth), 
													  size, 
													  size));
				}
			}
			
			CGContextStrokeEllipseInRect(context, mapRect);
			
			//test with text
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.2));
			CGContextSelectFont (context, "Helvetica Neue" , 1, kCGEncodingMacRoman);
			CGContextSetTextDrawingMode (context, kCGTextFill);
			CGContextShowTextAtPoint(context, origin.x - 6, origin.y + radius + 5, (const char*)"N", (size_t)1);		
			CGContextShowTextAtPoint(context, origin.x - radius - 17, origin.y, (const char*)"W", (size_t)1);		
			CGContextShowTextAtPoint(context, origin.x - 6, origin.y - radius - 17, (const char*)"Z", (size_t)1);		
			CGContextShowTextAtPoint(context, origin.x + radius + 5, origin.y, (const char*)"O", (size_t)1);		
			
			//test with ecliptic
			/* CGFloat dash1[] = {5.0, 8.0};
			
			CGContextSetLineWidth(context, 2.0);
			CGContextSetLineDash(context, 0.0, dash1, 2);	
			CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(0.4, 0.1, 0.1, 1.0));
			CGContextBeginPath(context);
			CGContextMoveToPoint(context, origin.x + radius*cos(M_PI), origin.y + radius*sin(M_PI));
			CGContextAddCurveToPoint(context, 
									 origin.x + 0.5*radius*cos(4), origin.y + 0.5*radius*sin(4), 
									 origin.x + 0.5*radius*cos(5), origin.y + 0.5*radius*sin(5), 
									 origin.x + radius*cos(0), origin.y + radius*sin(0));
			CGContextStrokePath(context); */
			
			
			break;
		
		default:
			break;
	}
	
}



@end
