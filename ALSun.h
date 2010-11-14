//
//  ALSun.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 06-11-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ALSun : NSObject {
	float ra;
	float dec;

	NSString* name;
	
	float x;
	float y;
	float z;
}

@property(readonly) float x, y, z, ra, dec, size;
@property(retain, readwrite) NSString *name;


@end
