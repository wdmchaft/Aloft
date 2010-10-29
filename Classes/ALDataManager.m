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
		planets = [[NSMutableArray alloc] init];
		positions = [[NSMutableArray alloc] init];
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
		const char *sqlStatement = "select id,hip,gliese,bayerflamsteed,propername,ra,dec,mag,colorindex from hyg order by mag limit 50000";
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
	
	//get names and positions for labels
	NSMutableArray* stringArray = [[NSMutableArray arrayWithCapacity:1] retain]; 
	fullPath = [[NSBundle mainBundle] pathForResource:@"constellation_positions" ofType:@"txt"];
	fileContents = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&e];//Assuming UTF8 encoding
	if (fileContents){
		NSEnumerator * lineEnumerator = [[fileContents componentsSeparatedByString:@"\n" ] objectEnumerator]; 
		NSString * enumeratedLine; 
		// Prepare to process each line of numbers 
		NSEnumerator * numberEnumerator; 
					
		while (enumeratedLine = [lineEnumerator nextObject]) { 
			numberEnumerator = [[enumeratedLine componentsSeparatedByString:@" "] objectEnumerator]; 
			NSString* string;
			while (string = [numberEnumerator nextObject]) { 
				[stringArray addObject:[NSString stringWithString:string]]; 
			} 
		} 
	}
	else{ NSLog(@"error # %i : %@", [e code], [e localizedDescription]); }
	
	for(int i = 0; i < [stringArray count] - 3; i += 3) {	
		float ra, dec;
		NSScanner* scanner = [NSScanner scannerWithString:[stringArray objectAtIndex:i + 1]];
		[scanner scanFloat: &ra];
		scanner = [NSScanner scannerWithString:[stringArray objectAtIndex:i + 2]];
		[scanner scanFloat: &dec];

		
		struct Pos position;
		struct Constellation aConstellation;
		aConstellation.name = [stringArray objectAtIndex:i];
		position.ra = ra;
		position.dec = 180 - dec;
		aConstellation.pos = position;
		
		//NSLog(@"%@, %f, %f", aConstellation.name, position.ra, position.dec);
		
		NSValue *boxedConst = [NSValue valueWithBytes:&aConstellation objCType:@encode(struct Constellation)];
		[constellations addObject:boxedConst];
	}
	sqlite3_close(database);
	NSLog(@".. done");
	
	NSLog(@"Loading planets");
	
	ALPlanet* Earth = [[ALPlanet alloc] initWithName:@"Earth" color:CGColorCreateGenericRGB(1.0, 1.0, 0.0, 1.0) size:10.0];
	[Earth setOrbitalElementsa:1.0 e:0.01671 i:0.0 w:288.064 o:174.873 Mo:357.529];
	[Earth calculatePosition];		
	
	ALPlanet* Mercury = [[ALPlanet alloc] initWithName:@"Mercurius" color:CGColorCreateGenericRGB(0.5, 0.5, 0.5, 1.0) size:4.0];
	[Mercury setOrbitalElementsa:0.38710 e:0.20563 i:7.005 w:29.125 o:48.331 Mo:174.795];
	[Mercury calculatePosition];
	[Mercury setOriginx:Earth.X y:Earth.Y z:Earth.Z];
	[planets addObject:Mercury]; 
	
	ALPlanet* Venus = [[ALPlanet alloc] initWithName:@"Venus" color:CGColorCreateGenericRGB(0.0, 1.0, 0.0, 1.0) size:5.0];
	[Venus setOrbitalElementsa:0.72333 e:0.00677 i:3.395 w:54.884 o:76.680 Mo:50.416];
	[Venus calculatePosition];
	[Venus setOriginx:Earth.X y:Earth.Y z:Earth.Z];
	[planets addObject:Venus]; 
	
	ALPlanet* Mars = [[ALPlanet alloc] initWithName:@"Mars" color:CGColorCreateGenericRGB(1.0, 0.0, 0.0, 1.0) size:5.0];
	[Mars setOrbitalElementsa:1.52368 e:0.09340 i:1.850 w:286.502 o:49.558 Mo:19.373];
	[Mars calculatePosition];
	[Mars setOriginx:Earth.X y:Earth.Y z:Earth.Z];
	[planets addObject:Mars]; 
	
	ALPlanet* Jupiter = [[ALPlanet alloc] initWithName:@"Jupiter" color:CGColorCreateGenericRGB(1.0, 0.5, 0.0, 1.0) size:5.0];
	[Jupiter setOrbitalElementsa:5.20260 e:0.04849 i:1.303 w:273.867 o:100.464 Mo:20.020];
	[Jupiter calculatePosition];
	[Jupiter setOriginx:Earth.X y:Earth.Y z:Earth.Z];
	[planets addObject:Jupiter]; 
	
	ALPlanet* Saturn = [[ALPlanet alloc] initWithName:@"Saturn" color:CGColorCreateGenericRGB(0.8, 0.5, 0.0, 1.0) size:5.0];
	[Saturn setOrbitalElementsa:9.55491 e:0.05551 i:2.489 w:339.391 o:113.666 Mo:317.021];
	[Saturn calculatePosition];
	[Saturn setOriginx:Earth.X y:Earth.Y z:Earth.Z];
	[planets addObject:Saturn]; 
	
	ALPlanet* Uranus = [[ALPlanet alloc] initWithName:@"Uranus" color:CGColorCreateGenericRGB(0.0, 0.5, 1.0, 1.0) size:3.0];
	[Uranus setOrbitalElementsa:19.21845 e:0.04630 i:0.773 w:98.999 o:74.006 Mo:141.050];
	[Uranus calculatePosition];
	[Uranus setOriginx:Earth.X y:Earth.Y z:Earth.Z];
	[planets addObject:Uranus]; 
	
	ALPlanet* Neptune = [[ALPlanet alloc] initWithName:@"Neptune" color:CGColorCreateGenericRGB(0.0, 0.2, 1.0, 1.0) size:3.0];
	[Neptune setOrbitalElementsa:30.11039 e:0.00899 i:1.770 w:276.340 o:131.784 Mo:256.225];
	[Neptune calculatePosition];
	[Neptune setOriginx:Earth.X y:Earth.Y z:Earth.Z];
	[planets addObject:Neptune]; 
		
	NSLog(@".. done");
}

-(NSArray*)planets {
	//recalculate planet positions
	return planets;
}

-(NSMutableArray*)stars {
	return stars;
}

-(NSMutableArray*)positions {
	return positions;
}
-(NSMutableArray*)constellations {
	return constellations;
}


@end
