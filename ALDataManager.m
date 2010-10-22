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
				
				theStar.ra = (sqlite3_column_double(compiledStatement, 5) * (M_PI/12));
				theStar.dec = sqlite3_column_double(compiledStatement, 6) + 90;
				theStar.mag = sqlite3_column_double(compiledStatement, 7);
				
				NSValue *boxedStar = [NSValue valueWithBytes:&theStar objCType:@encode(struct Star)];
				[stars addObject:boxedStar];
			}
		}
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	NSLog(@".. done");
}

-(NSMutableArray*)stars {
	return stars;
}


@end
