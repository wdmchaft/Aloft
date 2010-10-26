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
		positions = [[NSMutableArray alloc] init];
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
		const char *sqlStatement = "select id,hip,gliese,bayerflamsteed,propername,ra,dec,mag,colorindex from hyg order by mag limit 5000";
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
	NSLog(@".. done");
	
	NSLog(@"Loading: Constellations");
	
	NSMutableArray * numberArray = [[NSMutableArray arrayWithCapacity:1] retain]; 
	NSError *e;
	NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"constellation_lines" ofType:@"txt"];
	NSString *fileContents = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&e];//Assuming UTF8 encoding
	if (fileContents){
		NSEnumerator * lineEnumerator = [[fileContents componentsSeparatedByString:@"\n" ] objectEnumerator]; 
		NSString * enumeratedLine; 
		// Prepare to process each line of numbers 
		NSEnumerator * numberEnumerator; 
		NSString * numberAsString; 
		NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		
		while (enumeratedLine = [lineEnumerator nextObject]) { 
			numberEnumerator = [[enumeratedLine componentsSeparatedByString:@" "] objectEnumerator]; 
			while (numberAsString = [numberEnumerator nextObject]) { 
				[numberArray addObject:[f numberFromString:numberAsString]]; 
			} 
		} 
	}
	else{ NSLog(@"error # %i : %@", [e code], [e localizedDescription]); }
		
	
	for(int i = 0; i < [numberArray count]; ++i) {	
		NSString *sqlStatement = [NSString stringWithFormat:@"select id,hip,gliese,bayerflamsteed,propername,ra,dec,mag,colorindex from hyg where hip = %i limit 1", [[numberArray objectAtIndex:i] integerValue]];
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				struct Pos pos;
				
				pos.ra = (sqlite3_column_double(compiledStatement, 5) * (M_PI/12));
				pos.dec = sqlite3_column_double(compiledStatement, 6) + 90;
				
				NSValue *boxedPos1 = [NSValue valueWithBytes:&pos objCType:@encode(struct Pos)];
				[positions addObject:boxedPos1];
			}
		}
		sqlite3_finalize(compiledStatement);
	}
	
	NSLog(@".. done");
	
	sqlite3_close(database);
}

-(NSMutableArray*)stars {
	return stars;
}

-(NSMutableArray*)positions {
	return positions;
}
-(NSArray*)constellations {
	return constellations;
}


@end
