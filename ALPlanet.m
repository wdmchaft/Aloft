//
//  ALPlanet.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 29-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ALPlanet.h"

@implementation ALPlanet

@synthesize X, Y, Z, ra, dec, size, color, name;

-(id)initWithName:(NSString*)aName color:(CGColorRef)aColor size:(float)theSize {
	if(self = [super init]) {
		name = aName;
		color = aColor;
		size = theSize;
	}
	return self;
}

-(void)setOrbitalElementsa:(float)theA e:(float)theE i:(float)theI w:(float)theW o:(float)theO Mo:(float)theMo {
	a = theA;
	e = theE;
	i = theI * (M_PI / 180);
	w = theW * (M_PI / 180);
	o = theO * (M_PI / 180);
	Mo = theMo;
}

-(void)calculatePosition {
	float d = [[ALTimeManager shared] julianDay]; 
	
	float n = (M_PI / 180) * (0.9856076686/(a*sqrt(a)));
	float meanAnomaly = ((M_PI / 180) * Mo) + n*(d);
	
	float Ea = meanAnomaly; 
	float E;
	float di = 0;
	
	while(di <= 15) {
		E = Ea;
		Ea = E + ((meanAnomaly + (e*sin(E)) - E)/(1-(e*cos(E))));
		++di;
	}
	
	float eccentricAnomaly = Ea;
	
	float trueAnomaly = 2*atan(sqrt((1+e)/(1-e))*tan(eccentricAnomaly / 2));
	
	float distance = a*(1 - pow(e,2))/(1 + e*cos(trueAnomaly));
	
	X = distance * (cos(o)*cos(w + trueAnomaly) - sin(o)*cos(i)*sin(w + trueAnomaly));
	Y = distance * (sin(o)*cos(w + trueAnomaly) + cos(o)*cos(i)*sin(w + trueAnomaly));
	Z = distance * (sin(i) * sin(w + trueAnomaly)); 
	//alert(name + ": { " + X + ", " + Y + ", " + Z + " }");
}

-(void)setOriginx:(float)theX y:(float)theY z:(float)theZ {
	x = X - theX;
	y = Y - theY;
	z = Z - theZ;
	
	
	//alert(name + "x: { " + x + ", " + y + ", " + z + " }");
	
	float obliquity = 23.4397 * (M_PI / 180);
	
	float distance = (sqrt(pow(x,2)+pow(y,2)+pow(z,2)));
	
	float eclipticLongitude = atan2(y,x);
	float eclipticLatitude = asin(z/distance);
	
	ra = atan2(sin(eclipticLongitude)*cos(obliquity)-tan(eclipticLatitude)*sin(obliquity), cos(eclipticLongitude));
	dec = asin(sin(eclipticLatitude)*cos(obliquity)+cos(eclipticLatitude)*sin(obliquity)*sin(eclipticLongitude));
	
	dec = 90 - (dec * (180 / M_PI));
	
}
@end
