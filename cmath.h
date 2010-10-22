//
//  cmath.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/* CELESTIAL MATH */

/* computing star positions */
float computeAzimuth(float t, float ra, float dec, float lat, float lon);
float computeAltitude(float t, float ra, float dec, float lat, float lon);
