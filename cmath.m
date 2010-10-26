//
//  cmath.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

float computeAzimuth(float t, float ra, float dec, float lat, float lon) {	
	float H = t + lon - ra;
	float d = (M_PI / 180) * (dec - 90);
	float azimuth = (atan2(sin(H), cos(H) * sin(lat) - ( tan(d) * cos(lat) ) ) - M_PI / 2);
	if(azimuth < 0) {
		azimuth += 2 * M_PI;
	}
	return azimuth; //0 < azi < 2 * M_PI
}

float computeAltitude(float t, float ra, float dec, float lat, float lon) {
	float H = t + lon - ra;
	float d = (M_PI / 180) * (dec - 90);

	float altitude = ((180 / M_PI) * asin(sin(lat) * sin(d) + (cos(lat) * cos(d) * cos(H)) ));
	return altitude;	//-90 < alt < 90
}