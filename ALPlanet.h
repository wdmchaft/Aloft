//
//  ALPlanet.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 29-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALTimeManager.h"

@interface ALPlanet : NSObject {
	float ra;
	float dec;
	float size;
	CGColorRef color;
	NSString* name;
	
	float a; 
	float e;
	float i;
	float w;
	float o;
	float Mo;
	
	float X;
	float Y;
	float Z;
	
	float x;
	float y;
	float z;
}

@property(readonly) float X, Y, Z, ra, dec, size;
@property(retain, readwrite) NSString *name;
@property(readonly) CGColorRef color;


-(id)initWithName:(NSString*)aName color:(CGColorRef)aColor size:(float)theSize;
-(void)setOrbitalElementsa:(float)theA e:(float)theE i:(float)theI w:(float)theW o:(float)theO Mo:(float)theMo;
-(void)calculatePosition;
-(void)setOriginx:(float)theX y:(float)theY z:(float)theZ;

@end
