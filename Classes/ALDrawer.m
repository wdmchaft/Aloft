//
//  ALDrawer.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ALDrawer.h"

@implementation ALDrawer

@synthesize zoomValue, origin;

-(void)setZoomValue:(float)aValue {
	if(aValue < 1.0) {
		zoomValue = 1;
	}
	else {
		zoomValue = aValue;
	}
}

-(id)init {
	if(self = [super init]) {
		zoomValue = 1;
		origin.ra = M_PI;
		origin.dec = 0;
		srand(time(NULL));
		for(int i = 0; i < 88; ++i) {
			Pos tmpPos;
			tmpPos.ra = (((rand() % 628) + 1) / 100);
			tmpPos.dec = (((rand() % 18000) + 1));
			constellationpos[i] = tmpPos;	
		}
	}
	return self;
}

-(void)drawMap:(ViewType)viewType InContext:(CGContextRef)context viewRect:(CGRect)viewRect {
	NSMutableArray* stars = [[ALDataManager shared] stars];
	NSMutableArray* positions = [[ALDataManager shared] positions];
	NSMutableArray* constellations = [[ALDataManager shared] constellations];
	
	CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.05, 0.05, 0.05, 1.0));
	CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(0.1, 0.1, 0.1, 1.0));
	CGContextSetLineWidth(context, 1.0);
	CGContextFillRect(context, viewRect);		
	float radius;
	int size;
	float h = [[ALTimeManager shared] elapsed];
	float width = viewRect.size.width;
	float height = viewRect.size.height;
	
	switch (viewType) {
		case SkyView:
			radius = viewRect.size.height;
			//geometric variables						
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 0.0, 0.0, 0.9));
			
			//test with text
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(0.18, 0.205, 0.245, 1.0)); 
			CGContextSelectFont (context, "Didot" , 8, kCGEncodingMacRoman);
			CGContextSetCharacterSpacing(context, 3);
			CGContextSetTextDrawingMode (context, kCGTextFill);
			CGContextSetLineWidth(context, 0.5);
			CGContextSetShadow(context, CGSizeMake(0, 0), 3);
			
			for(int i = 0; i < [constellations count]; ++i) {
			//draw constellation text test
				NSValue* boxedConstellation = [constellations objectAtIndex:i];
				struct Constellation aConstellation;
				if (strcmp([boxedConstellation objCType], @encode(struct Constellation)) == 0) {
					[boxedConstellation getValue:&aConstellation]; }			
				
				float azimuth = computeAzimuth(h, aConstellation.pos.ra, aConstellation.pos.dec, 0.90754, 0.08722);
				float altitude = computeAltitude(h, aConstellation.pos.ra, aConstellation.pos.dec, 0.90754, 0.08722);
				
				CGContextShowTextAtPoint(context, 
										 (width / 2 + ((width / 2) * ((azimuth - origin.ra) / (M_PI)) * zoomValue)) - (5 * [aConstellation.name length]),
										 (height / 2 + ((height / 2) * ((altitude - origin.dec) / 90) * zoomValue)), 
										 [[aConstellation.name uppercaseString] UTF8String], (size_t)[aConstellation.name length]);	//[[[ALDataManager shared] constellations] objectAtIndex:i] 
			}
						
			//draw constellations
			CGContextBeginPath(context);
			float azimuth_old = M_PI;
			for(int i = 0; i < [positions count]; ++i) {
				NSValue* boxedPos = [positions objectAtIndex:i];
				struct Pos aPos;

				if (strcmp([boxedPos objCType], @encode(struct Pos)) == 0) {
					[boxedPos getValue:&aPos]; 
				
					float azimuth = computeAzimuth(h, aPos.ra, aPos.dec, 0.90754, 0.08722);
					float altitude = computeAltitude(h, aPos.ra, aPos.dec, 0.90754, 0.08722);

					if((i % 2) == 0) {
						CGContextMoveToPoint(context,	(width / 2 + ((width / 2) * ((azimuth - origin.ra) / (M_PI)) * zoomValue)),
											 (height / 2 + ((height / 2) * ((altitude - origin.dec) / 90) * zoomValue)));
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
						 CGContextAddLineToPoint(context,	(width / 2 + ((width / 2) * ((azimuth - origin.ra) / (M_PI)) * zoomValue)),
																(height / 2 + ((height / 2) * ((altitude - origin.dec) / 90) * zoomValue)));
					}
				}

			}
			
			CGContextClosePath(context);
						
			CGContextSetStrokeColorWithColor(context, CGColorCreateGenericRGB(0.4, 0.65, 1.0, (1 - (1/(2*zoomValue))) * 0.15));
			CGContextSetLineWidth(context, 2.0);
			CGContextStrokePath(context);
			
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.9));
			for(int i = 0; i < [stars count]; ++i) {
				NSValue* boxedStar = [stars objectAtIndex:i];
				struct Star aStar;
				if (strcmp([boxedStar objCType], @encode(struct Star)) == 0) {
					[boxedStar getValue:&aStar]; }			
				
				if(aStar.mag < 1.0) { size = 6; }
				else if(aStar.mag < 2.0) { size = 5; }
				else if(aStar.mag < 3.0) { size = 3; }
				else { size = 1; }
				
				if(aStar.mag < 3.0) { CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.9)); }
				else { CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.5)); } // CHANGE THIS, USE SORTY BY MAG
								
				float azimuth = computeAzimuth(h, aStar.pos.ra, aStar.pos.dec, 0.90754, 0.08722);
				float altitude = computeAltitude(h, aStar.pos.ra, aStar.pos.dec, 0.90754, 0.08722);
				
				CGContextFillEllipseInRect(context, 
										   CGRectMake((width / 2 + ((width / 2) * ((azimuth - origin.ra) / (M_PI)) * zoomValue)),
													  (height / 2 + ((height / 2) * ((altitude - origin.dec) / 90) * zoomValue)),
													  size, 
													  size));
			}
				
			//draw planets
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 0.7, 0.7, 0.9));
			float size = 5;
			float azimuth = computeAzimuth(h, (22/12) * M_PI, -11, 0.90754, 0.08722);
			float altitude = computeAltitude(h, (22/12) * M_PI, -11, 0.90754, 0.08722);
			
			CGContextFillEllipseInRect(context, 
									   CGRectMake((width / 2 + ((width / 2) * ((azimuth - origin.ra) / (M_PI)) * zoomValue)),
												  (height / 2 + ((height / 2) * ((altitude - origin.dec) / 90) * zoomValue)),
												  size, 
												  size));			
			

			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0));
			CGContextSelectFont (context, "Helvetica-Bold" , 11, kCGEncodingMacRoman);
			CGContextSetCharacterSpacing(context, 1);
			CGContextShowTextAtPoint(context, 
									 (width / 2 + ((width / 2) * ((azimuth - origin.ra) / (M_PI)) * zoomValue)) - 25,
									 (height / 2 + ((height / 2) * ((altitude - origin.dec) / 90) * zoomValue)) - 10,
									 (const char*)"Jupiter", (size_t)7);	//[[[ALDataManager shared] constellations] objectAtIndex:i]
			
			break;
		
		case StarMap:			
			//geometric variables
			radius = (viewRect.size.height - 100) / 2;
			
			CGPoint mapOrigin = CGPointMake(viewRect.size.width / 2, viewRect.size.height / 2 + 30);

			CGRect mapRect = {	
				mapOrigin.x - radius, 
				mapOrigin.y - radius,
				radius * 2, 
				radius * 2};
			
			
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.05));
			CGContextFillEllipseInRect(context, mapRect);
			
			//test with text
			CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.2));
			CGContextSelectFont (context, "Helvetica-Neue" , 12, kCGEncodingMacRoman);
			CGContextSetTextDrawingMode (context, kCGTextFill);
			CGContextShowTextAtPoint(context, mapOrigin.x - 6, mapOrigin.y + radius + 5, (const char*)"N", (size_t)1);		
			CGContextShowTextAtPoint(context, mapOrigin.x - radius - 17, mapOrigin.y, (const char*)"W", (size_t)1);		
			CGContextShowTextAtPoint(context, mapOrigin.x - 6, mapOrigin.y - radius - 17, (const char*)"Z", (size_t)1);		
			CGContextShowTextAtPoint(context, mapOrigin.x + radius + 5, mapOrigin.y, (const char*)"O", (size_t)1);		
			
			
			//draw constellations
			CGContextBeginPath(context);
			azimuth_old = M_PI;
			BOOL skipline = FALSE;
			for(int i = 0; i < [positions count]; ++i) {
				NSValue* boxedPos = [positions objectAtIndex:i];
				struct Pos aPos;
				
				if (strcmp([boxedPos objCType], @encode(struct Pos)) == 0) {
					[boxedPos getValue:&aPos]; 
					
					float azimuth = computeAzimuth(h, aPos.ra, aPos.dec, 0.90754, 0.08722);
					float altitude = computeAltitude(h, aPos.ra, aPos.dec, 0.90754, 0.08722);
					
					if((i % 2) == 0) {
						if(altitude > 0) {
							CGContextMoveToPoint(context, mapOrigin.x + ((90 - altitude) / 90)*radius*cos(azimuth), mapOrigin.y + ((90 - altitude) / 90)*radius*sin(azimuth));	
						}
						else {
							skipline = TRUE;	
						}
					}
					else {
						if(altitude > 0 && !skipline) {
						CGContextAddLineToPoint(context, mapOrigin.x + ((90 - altitude) / 90)*radius*cos(azimuth), mapOrigin.y + ((90 - altitude) / 90)*radius*sin(azimuth));	
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
				
				float azimuth = computeAzimuth(h, aStar.pos.ra, aStar.pos.dec, 0.90754, 0.08722);
				float altitude = computeAltitude(h, aStar.pos.ra, aStar.pos.dec, 0.90754, 0.08722);
				if(altitude > 0) {
					CGContextFillEllipseInRect(context, 
										   CGRectMake(mapOrigin.x + ((90 - altitude) / 90)*radius*cos(azimuth), 
													  mapOrigin.y + ((90 - altitude) / 90)*radius*sin(azimuth), 
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



@end
