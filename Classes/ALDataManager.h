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

typedef struct Constellation {
	NSString* name;
	int size;
	Pos points[];
} Constellation;

@interface ALDataManager : NSObject {
	NSString* dbPath;
	NSMutableArray* stars;
	NSMutableArray* constellations;
}

+ (id)shared;
- (void)getData;
- (NSMutableArray*)stars;
- (NSMutableArray*)constellations;

@end
