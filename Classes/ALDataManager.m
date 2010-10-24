//
//  ALDataManager.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ALDataManager.h"

@implementation ALDataManager

static id sharedManager = nil;

+ (void)initialize {
    if (self == [ALDataManager class]) {
        sharedManager = [[self alloc] init];
    }
}

-(id)init {
	NSLog(@"init data");

	if(self = [super init]) {
		NSString *dbName = @"database.db";
		dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
		stars = [[NSMutableArray alloc] init];
		constellations = [[NSMutableArray alloc] init];

		[self getData];
	}
	
	return self;
}

+ (id)shared {
    return sharedManager;
}

-(void)getData {
	NSLog(@"Loading: Stars");
	sqlite3 *database;
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "select id,hip,gliese,bayerflamsteed,propername,ra,dec,mag,colorindex from hyg order by mag limit 2000";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				struct Star theStar; 
				
				theStar.pos.ra = (sqlite3_column_double(compiledStatement, 5) * (M_PI/12));
				theStar.pos.dec = sqlite3_column_double(compiledStatement, 6) + 90;
				theStar.mag = sqlite3_column_double(compiledStatement, 7);
				
				NSValue *boxedStar = [NSValue valueWithBytes:&theStar objCType:@encode(struct Star)];
				[stars addObject:boxedStar];
			}
		}
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	NSLog(@".. done");
	
	NSLog(@"Loading: Constellations");
	
	struct Constellation *antlia;
	struct Pos pos1;
	struct Pos pos2;
	
	pos1.ra = 10.4525433 * (M_PI / 12);
	pos1.dec = -31.06780228 + 90;
	pos2.ra = 9.98120556 * (M_PI / 12);
	pos2.dec = -35.89093311 + 90;
	
	int siz = 8;
    antlia = malloc(sizeof(Constellation) + siz * sizeof(Pos));
    antlia->size = siz;
	antlia->name = @"Antlia";
	antlia->points[0] = pos1;
	antlia->points[1] = pos2;

	NSValue *boxedConstellation = [NSValue valueWithBytes:&antlia objCType:@encode(struct Constellation)];
	[constellations addObject:boxedConstellation];

	NSLog(@".. done");
}

-(NSMutableArray*)stars {
	return stars;
}

-(NSMutableArray*)constellations {
	return constellations;
}


@end
