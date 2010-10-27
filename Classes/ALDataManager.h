//
//  ALDataManager.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <sqlite3.h>

typedef struct Pos {
	float ra;
	float dec;
} Pos;

struct Star {
	Pos pos;
	float mag;
};

struct Planet {
	NSString* name;
	CGColorRef color;
	Pos pos;
	//variables
};

struct Constellation {
	NSString* name;
	Pos pos;
} Constellation;

@interface ALDataManager : NSObject {
	NSString* dbPath;
	NSMutableArray* stars;
	NSMutableArray* constellations;
	NSMutableArray* positions;

}

+ (id)shared;
- (void)getData;
- (NSMutableArray*)stars;
- (NSMutableArray*)constellations;
- (NSMutableArray*)positions;

@end
