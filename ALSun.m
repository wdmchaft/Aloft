//
//  ALSun.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 06-11-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ALSun.h"


@implementation ALSun
@synthesize name, x, y, z, size, ra, dec;

-(id)initWithx:(float)theX y:(float)theY z:(float)theZ {
	if(self = [super init]) {
		name = @"Sun";
		
		x = -theX;
		y = -theY;
		z = -theZ;
		
		float obliquity = 23.4397 * (M_PI / 180);
		
		float distance = (sqrt(pow(x,2)+pow(y,2)+pow(z,2)));
		
		float eclipticLongitude = atan2(y,x);
		float eclipticLatitude = asin(z/distance);
		
		ra = atan2(sin(eclipticLongitude)*cos(obliquity)-tan(eclipticLatitude)*sin(obliquity), cos(eclipticLongitude));
		dec = asin(sin(eclipticLatitude)*cos(obliquity)+cos(eclipticLatitude)*sin(obliquity)*sin(eclipticLongitude));
		
		dec = 90 - (dec * (180 / M_PI));
	}
	return self;
}	

@end
